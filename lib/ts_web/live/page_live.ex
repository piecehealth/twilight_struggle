defmodule TsWeb.PageLive do
  use TsWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign_defaults(session) |> assign(game: Ts.Game.View.blank())}
  end

  @impl true
  def handle_event("update_usa_infl", %{"country" => country, "direction" => "increase"}, socket) do
    game = socket.assigns.game
    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    game = put_in(game.countries[country], {usa_influence + 1, ussr_influence})
    {:noreply, assign(socket, game: game)}
  end

  @impl true
  def handle_event("update_ussr_infl", %{"country" => country, "direction" => "increase"}, socket) do
    game = socket.assigns.game
    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    game = put_in(game.countries[country], {usa_influence, ussr_influence + 1})
    {:noreply, assign(socket, game: game)}
  end
end
