defmodule TsWeb.GameLive do
  use TsWeb, :live_view

  alias Ts.Server.RoomManager

  @impl true
  def mount(%{"id" => room_id}, session, socket) do
    socket = assign_defaults(socket, session)

    if socket.assigns.user_id do
      {room, game} = RoomManager.get_room(room_id)
      {:ok, assign(socket, room: room, game: game)}
    else
      {:ok, push_redirect(socket, to: "/")}
    end
  end

  @doc """
  Choose superpower for host player.
  """
  @impl true
  def handle_event("choose_side", %{"value" => side}, socket) do
    %{room: room, user_id: user_id} = socket.assigns

    if side in ["random", "usa", "ussr"] && room.status == :new && room.host_id == user_id &&
         side != room.host_superpower do
      room = RoomManager.update_side(room.room_id, side)
      {:noreply, assign(socket, room: room)}
    else
      {:noreply, socket}
    end
  end
end
