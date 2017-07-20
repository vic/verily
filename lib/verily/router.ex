defmodule Verily.Router do
  use Phoenix.Router

  forward "/inbox", Bamboo.SentEmailViewerPlug, []

  scope "/graphql" do
    get "/", Absinthe.Plug.GraphiQL, schema: Verily.GQL
    forward "/", Absinthe.Plug, schema: Verily.GQL
  end

  get "/favicon.ico", Verily.Index, [:not_found]
  forward "/", Verily.Index, []

end
