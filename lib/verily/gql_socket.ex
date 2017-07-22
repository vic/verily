defmodule Verily.GQL.Socket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false

  def connect(_params, socket) do
    {:ok, assign(socket, :absinthe, %{schema: Verily.GQL.Schema})}
  end

  def id(_socket), do: nil
end
