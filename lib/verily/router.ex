defmodule Verily.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/favicon.ico" do
    send_resp(conn, 400, "not found")
  end

  forward "/", to: Verily.Index

end
