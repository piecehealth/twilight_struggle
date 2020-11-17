defmodule Ts.Server.RoomManager do
  use DynamicSupervisor

  alias Ts.Server.Room
  alias Ts.Server.RoomAgent

  # Client API
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def new_room(user_id) do
    {room_pids, _} = Agent.get(RoomAgent, & &1)

    room_id = gen_room_id(room_pids)

    # TODO: remove dead rooms

    DynamicSupervisor.start_child(__MODULE__, %{
      id: "ts_room:" <> room_id,
      start: {Room, :start_link, [room_id, user_id]}
    })

    room_id
  end

  # Server API

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp gen_room_id(room_pids) do
    id = Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))

    if Map.has_key?(room_pids, id), do: gen_room_id(room_pids), else: id
  end
end
