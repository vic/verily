defmodule Verily.Verifier do
  use GenServer

  alias Verily.Endpoint

  def start_link(state = [{:token, token}| _]) do
    GenServer.start_link(__MODULE__, state, name: via(token))
  end

  def spawn(device, data) do
    token = rand_token()
    {:ok, _pid} = start_link([token: token, data: data, device: device])
    token
  end

  def init(state = [{:token, token} | _]) do
    IO.inspect({:verifier_init, state})
    {:ok, state, :timer.minutes(5)}
  end

  def rand_token do
    :crypto.strong_rand_bytes(16) |> Base.encode16
  end

  def verify(token) do
    Registry.lookup(__MODULE__, token)
    |> case do
      [] -> :error
      [{pid, nil}] -> GenServer.call(pid, :verify)
    end
  end

  def alias_to(token, alias_name) do
    GenServer.call(via(token), {:alias, alias_name})
  end

  def handle_call({:alias, name}, _from, state) do
    {:ok, _} = Registry.register(__MODULE__, name, nil)
    {:noreply, state}
  end

  def handle_call(:verify, _from, state) do
    IO.inspect({:verified, state})
    subscription_publish(state)
    {:stop, :normal, :ok, nil}
  end

  def handle_info(:timeout, state) do
    IO.inspect({:verifer_timeout, state})
    {:stop, :normal, state}
  end

  defp subscription_publish([token: token, data: data, device: device]) do
    Absinthe.Subscription.publish(Endpoint, data, [viewer: device])
  end

  defp via(token) do
    {:via, Registry, {__MODULE__, token}}
  end

end
