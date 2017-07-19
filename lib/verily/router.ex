defmodule Verily.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/favicon.ico" do
    send_resp(conn, 404, "not found")
  end

  forward "/inbox", to: Bamboo.SentEmailViewerPlug
  forward "/", to: Verily.Index

end
