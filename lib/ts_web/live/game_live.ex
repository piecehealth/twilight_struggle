defmodule TsWeb.GameLive do
  use TsWeb, :live_view

  alias Ts.Server.Room

  @impl true
  def mount(%{"id" => room_id}, session, socket) do
    socket = assign_defaults(socket, session)
    user_id = socket.assigns.user_id

    if user_id do
      if connected?(socket) do
        Phoenix.PubSub.subscribe(Ts.PubSub, "room:" <> room_id)
      end

      case Room.get_room(room_id) do
        {room, game} ->
          {room, game} =
            if Room.can_join?(room, user_id) do
              Room.join(room_id, user_id)
            else
              {room, game}
            end

          {:ok, assign(socket, room: room, game: game)}

        _ ->
          {:ok, push_redirect(socket, to: "/")}
      end
    else
      {:ok, push_redirect(socket, to: "/register?room_id=" <> room_id)}
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
      {room, _} = Room.update_side(room.room_id, side)
      {:noreply, assign(socket, room: room)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "update_room",
          topic: topic,
          payload: room
        },
        socket
      ) do
    if topic == "room:" <> socket.assigns.room.room_id do
      {:noreply, assign(socket, room: room)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "update_game",
          topic: topic,
          payload: game
        },
        socket
      ) do
    if topic == "room:" <> socket.assigns.room.room_id do
      {:noreply, assign(socket, game: game)}
    else
      {:noreply, socket}
    end
  end
end
