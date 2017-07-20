defmodule Verily.Index do
  def init(x), do: x

  def call(conn, [:not_found]) do
    Plug.Conn.resp(conn, 404, "not found")
  end

  def call(conn, _) do
    Plug.Conn.resp(conn, 200, "<div id='app' /><script src='//localhost:3000/index.bundle.js'></script>")
  end
end
