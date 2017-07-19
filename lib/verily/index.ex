defmodule Verily.Index do
  def init(_) do
  end

  def call(conn, _) do
    Plug.Conn.resp(conn, 200, "<div id='app' /><script src='//localhost:3000/index.bundle.js'></script>")
  end
end
