defmodule TsWeb.PageLive do
  use TsWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign_defaults(session) |> assign(game: Ts.Game.Game.blank())}
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
end
