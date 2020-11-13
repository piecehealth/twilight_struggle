defmodule Ts.Server.RoomManager do
  use GenServer

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def new_room(user_id) do
    GenServer.call(__MODULE__, {:new_room, user_id})
  end

  def find_room(room_id) do
    GenServer.call(__MODULE__, {:new_room, room_id})
  end

  # Server API

  @impl true
  def init(:ok) do
    room_pids = %{}
    room_status = %{}

    {:ok, {room_pids, room_status}}
  end

  @impl true
  def hand_call({:new_room, user_id}, _from, state) do
    {:replay, user_id, state}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp gen_room_id(existing_ids) do
    Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))
  end
end
