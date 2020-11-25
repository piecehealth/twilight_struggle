defmodule TsWeb.GameLive do
  use TsWeb, :live_view

  alias Ts.Server.Room
  alias Ts.Game.Game

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

          game =
            cond do
              Room.usa_player?(room, user_id) -> Game.view_for(game, :usa)
              Room.ussr_player?(room, user_id) -> Game.view_for(game, :ussr)
              true -> game
            end

          {:ok,
           assign(socket,
             room: room,
             game: game,
             influence_change_log: init_influence_change_log()
           )}

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
  def handle_event("usa_plus_1", %{"country" => country}, socket) do
    game = socket.assigns.game
    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    game = put_in(game.countries[country], {usa_influence + 1, ussr_influence})
    {:noreply, assign(socket, game: game)}
  end

  @impl true
  def handle_event("ussr_plus_1", %{"country" => country}, socket) do
    game = socket.assigns.game
    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    game = put_in(game.countries[country], {usa_influence, ussr_influence + 1})
    {:noreply, assign(socket, game: game)}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "update_room",
          topic: topic,
          payload: %{room: room, game: game}
        },
        socket
      ) do
    %{user_id: user_id} = socket.assigns

    if topic == "room:" <> room.room_id do
      game =
        cond do
          Room.usa_player?(room, user_id) ->
            Game.view_for(game, :usa)

          Room.usa_player?(room, user_id) ->
            Game.view_for(game, :ussr)

          true ->
            game
        end

      {:noreply,
       assign(socket,
         room: room,
         game: game,
         influence_change_log: init_influence_change_log()
       )}
    else
      {:noreply, socket}
    end
  end

  defp init_influence_change_log() do
    %{}
  end
end
