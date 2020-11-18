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
            host_superpower: "random",
            last_updated_at: nil

  def start_link(room_id, user_id) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {room_id, user_id})
    RoomAgent.register(room_id, pid)
    {:ok, pid}
  end

  def get_room(room_id) do
    if get_pid(room_id) do
      GenServer.call(get_pid(room_id), {:get_room})
    else
      :error
    end
  end

  def update_side(room_id, host_superpower) do
    GenServer.call(get_pid(room_id), {:update_side, host_superpower})
  end

  def join(room_id, guest_id) do
    {room, game} = GenServer.call(get_pid(room_id), {:guest_join, guest_id})
    notify_room_updates(room)
    notify_game_updates(room.room_id, game)
    {room, game}
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

  def can_join?(room, user_id) do
    room.status == :new && room.host_id != user_id && is_nil(room.guest_id)
  end

  @impl true
  def init({room_id, user_id}) do
    {:ok,
     {%__MODULE__{
        room_id: room_id,
        host_id: user_id,
        host_pwd: gen_pwd(),
        last_updated_at: Timex.now()
      }, %Game{}}}
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

  @impl true
  def handle_call({:guest_join, guest_id}, _from, {room, game}) do
    {room, game} =
      if can_join?(room, guest_id) do
        {Map.merge(room, %{guest_id: guest_id, guest_pwd: gen_pwd(), status: :start}), Game.new()}
      else
        {room, game}
      end

    {:reply, {room, game}, {room, game}}
  end

  defp notify_room_updates(room) do
    Task.start(fn ->
      TsWeb.Endpoint.broadcast("room:" <> room.room_id, "update_room", room)
    end)
  end

  defp notify_game_updates(room_id, game) do
    Task.start(fn ->
      TsWeb.Endpoint.broadcast("room:" <> room_id, "update_game", game)
    end)
  end

  defp gen_pwd do
    Integer.to_string(:rand.uniform(9)) <> Integer.to_string(:rand.uniform(9999))
  end

  defp get_pid(room_id) do
    Ts.Server.RoomAgent.room_pid(room_id)
  end
end
