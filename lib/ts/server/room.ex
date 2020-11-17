defmodule Ts.Server.Room do
  use GenServer

  alias Ts.Game.Game
  alias Ts.Server.RoomAgent

  defstruct room_id: nil,
            status: :new,
            host_id: nil,
            host_pwd: nil,
            guest_id: nil,
            guest_pwd: nil,
            host_superpower: "random"

  def start_link(room_id, user_id) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {room_id, user_id})
    RoomAgent.register(room_id, pid)
    {:ok, pid}
  end

  def get_room(pid) do
    GenServer.call(pid, {:get_room})
  end

  def update_side(pid, host_superpower) do
    GenServer.call(pid, {:update_side, host_superpower})
  end

  def host?(room, user_id) do
    room.host_id == user_id
  end

  def guest?(room, user_id) do
    room.guest_id == user_id
  end

  def audience?(room, user_id) do
    !(host?(room, user_id) || guest?(room, user_id))
  end

  @impl true
  def init({room_id, user_id}) do
    host_pwd = gen_pwd()
    {:ok, {%__MODULE__{room_id: room_id, host_id: user_id, host_pwd: host_pwd}, %Game{}}}
  end

  @impl true
  def handle_call({:get_room}, _from, {room, game}) do
    {:reply, {room, game}, {room, game}}
  end

  @impl true
  def handle_call({:update_side, host_superpower}, _from, {room, game}) do
    room = Map.put(room, :host_superpower, host_superpower)
    {:reply, {room, game}, {room, game}}
  end

  defp gen_pwd do
    Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))
  end
end
