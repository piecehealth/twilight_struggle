defmodule Ts.Server.RoomManager do
  use GenServer

  alias Ts.Server.Room
  alias Ts.Server.RoomAgent

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new_room(user_id) do
    GenServer.call(__MODULE__, {:new_room, user_id})
  end

  def get_room(room_id, user_id) do
    GenServer.call(__MODULE__, {:get_room, room_id, user_id})
  end

  # Server API

  @impl true
  def init(:ok) do
    {:ok, :ok}
  end

  @impl true
  def handle_call({:new_room, user_id}, _from, :ok) do
    {room_pids, _} = Agent.get(RoomAgent, & &1)

    room_id = gen_room_id(room_pids)

    DynamicSupervisor.start_child(:room_guard, %{
      id: "ts_room:" <> room_id,
      start: {Room, :start_link, [room_id, user_id]}
    })

    {:reply, room_id, :ok}
  end

  @impl true
  def handle_call({:get_room, room_id, user_id}, _from, :ok) do
    room_pid = RoomAgent.room_pid(room_id)
    {:reply, Room.get_room(room_pid, user_id), :ok}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp gen_room_id(room_pids) do
    id = Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))

    if Map.has_key?(room_pids, id), do: gen_room_id(room_pids), else: id
  end
end
