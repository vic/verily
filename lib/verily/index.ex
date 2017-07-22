defmodule Verily.Index do
  alias Verily.Verifier

  def init(x), do: x

  def call(conn, [:not_found]) do
    Plug.Conn.resp(conn, 404, "not found")
  end

  def call(conn, [:verify]) do
    %{params: %{"token" => token}} = conn
    token
    |> Verifier.verify
    |> case do
         :ok -> Plug.Conn.resp(conn, 200, "token verified")
         :error -> Plug.Conn.resp(conn, 400, "invalid token")
       end
  end

  def call(conn, _) do
    Plug.Conn.resp(conn, 200, "<div id='app' /><script src='//localhost:3000/index.bundle.js'></script>")
  end
end
