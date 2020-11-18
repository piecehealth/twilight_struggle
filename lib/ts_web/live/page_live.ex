defmodule TsWeb.PageLive do
  use TsWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    countries = Ts.Game.Game.init_countries()

    game = %{
      countries: countries,
      can_add_usa_influence_countries: MapSet.new(Map.keys(countries)),
      can_add_ussr_influence_countries: MapSet.new(Map.keys(countries))
    }

    {:ok, assign_defaults(socket, session) |> assign(game: game)}
  end

  @impl true
  def handle_event("usa_plus_1", %{"country" => country}, socket) do
    {usa_influence, ussr_influence} = Map.get(socket.assigns.game.countries, country)

    game = put_in(socket.assigns.game, [:countries, country], {usa_influence + 1, ussr_influence})
    {:noreply, assign(socket, game: game)}
  end

  @impl true
  def handle_event("ussr_plus_1", %{"country" => country}, socket) do
    {usa_influence, ussr_influence} = Map.get(socket.assigns.game.countries, country)

    game = put_in(socket.assigns.game, [:countries, country], {usa_influence, ussr_influence + 1})
    {:noreply, assign(socket, game: game)}
  end
end
