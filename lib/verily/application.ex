defmodule Verily.Application do

  alias Verily.Endpoint
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(Endpoint, [])
    ]
    opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # let phoenix update endpoint on code reload
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end

end
