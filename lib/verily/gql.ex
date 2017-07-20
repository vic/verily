defmodule Verily.GQL do
  use Absinthe.Schema

  query do
    field :hello, type: :string do
      resolve(fn _, _, _ -> {:ok, "WORLD"} end)
    end
  end

end
