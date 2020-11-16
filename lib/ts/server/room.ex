defmodule Ts.Server.Room do
  use GenServer

  alias Ts.Server.RoomAgent

  defstruct room_id: nil,
            status: :new,
            game: nil,
            host_id: nil,
            host_pwd: nil,
            guest_id: nil,
            guest_pwd: nil

  def start_link(room_id, user_id) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {room_id, user_id})
    RoomAgent.register(room_id, pid)
    {:ok, pid}
  end

  def get_room(pid, user_id) do
    GenServer.call(pid, {:get_room, user_id})
  end

  @impl true
  def init({room_id, user_id}) do
    host_pwd = gen_pwd()
    {:ok, %__MODULE__{room_id: room_id, host_id: user_id, host_pwd: host_pwd}}
  end

  @impl true
  def handle_call({:get_room, user_id}, _from, state) do
    {:reply, state, state}
  end

  defp gen_pwd do
    Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))
  end
end
