defmodule Verily.GQL.Schema do
  use Absinthe.Schema

  alias Verily.Verify

  query do
    field :hello, type: :string do
      resolve &hello/3
    end

    field :viewer, type: :viewer do
      resolve &viewer/3
    end
  end

  mutation do
    field :email_login, type: :email_login_result do
      arg :email, type: non_null(:string)
      arg :device_token, type: non_null(:string)
      resolve &email_login/3
    end
  end

  subscription do
    field :viewer, :viewer do
      arg :device_token, non_null(:string)
      topic &(&1.device_token)
    end
  end

  object :email_login_result do
    field :token, :string
  end

  object :viewer do
    field :email, :string
  end

  defp hello(_parent, _variables, opts) do
    IO.inspect({:hello, opts})
    {:ok, "WORLD"}
  end

  defp email_login(_, %{email: email, device_token: device}, _) do
    {:ok, token} = Verify.verify_email(%{email: email}, device)
    {:ok, %{token: token}}
  end

  defp viewer(a, b, c) do
    IO.inspect({:viewer, a, b, c})
    {:ok, nil}
  end

end
