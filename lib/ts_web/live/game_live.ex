defmodule TsWeb.GameLive do
  use TsWeb, :live_view

  @impl true
  def mount(%{"id" => room_id}, session, socket) do
    socket = assign_defaults(socket, session)
    room = Ts.Server.RoomManager.get_room(room_id, socket.assigns.user_id)
    {:ok, assign(socket, room: room)}
  end

  @impl true
  def handle_event("incr", %{"country" => country}, socket) do
    countries = Map.update(socket.assigns.countries, country, 0, &(&1 + 1))
    {:noreply, assign(socket, countries: countries)}
  end
end
