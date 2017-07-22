defmodule Verily.Router do
  use Phoenix.Router

  forward "/inbox", Bamboo.SentEmailViewerPlug, []

  scope "/graphql" do
    get "/", Absinthe.Plug.GraphiQL, schema: Verily.GQL.Schema
    forward "/", Absinthe.Plug, schema: Verily.GQL.Schema
  end

  get "/favicon.ico", Verily.Index, [:not_found]
  get "/confirm/:token", Verily.Index, [:verify]

  forward "/", Verily.Index, []

end
