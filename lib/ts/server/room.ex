defmodule Ts.Server.Room do
  use GenServer

  alias Ts.Server.RoomAgent

  def start_link(room_id, user_id) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {room_id, user_id})
    RoomAgent.register(room_id, pid)
    {:ok, pid}
  end

  @impl true
  def init({room_id, user_id}) do
    {:ok, {room_id, user_id}}
  end
end
