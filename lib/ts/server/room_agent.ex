defmodule Ts.Server.RoomAgent do
  use Agent

  def start_link(_) do
    room_pids = %{}
    room_backup_status = %{}
    Agent.start_link(fn -> {room_pids, room_backup_status} end, name: __MODULE__)
  end

  def register(room_id, pid) do
    Agent.update(__MODULE__, fn {room_ids, room_backup_status} ->
      {Map.put(room_ids, room_id, pid), room_backup_status}
    end)
  end

  def room_pid(room_id) do
    {room_pids, _} = Agent.get(__MODULE__, & &1)
    Map.get(room_pids, room_id)
  end
end
