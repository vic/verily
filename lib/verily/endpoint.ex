defmodule Verily.Endpoint do

  use Phoenix.Endpoint, otp_app: :verily

  # socket "/graphql", Bussi.HTTP.GQL.Socket

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_verily_session",
    signing_salt: "Z7u6Xrca"

  plug Verily.Router

end
