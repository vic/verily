defmodule Verily.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "<div id='app' /><script src='//localhost:3000/index.bundle.js'></script>")
  end

  get "/favicon.ico" do
    send_resp(conn, 400, "not found")
  end
end
