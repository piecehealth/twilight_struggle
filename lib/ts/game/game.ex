defmodule Ts.Game.Game do
  defstruct status: :not_start,
            countries: %{},
            defcon_level: 5,
            phazing_player: :ussr,
            current_player: [:ussr],
            turn: 1,
            action_round: 1,
            current_card: nil,
            card_phaze: nil,
            card_choices: [],
            cards_in_deck: [],
            usa_cards: [],
            ussr_cards: [],
            logs: [],
            buffs: MapSet.new()

  alias Ts.Game.Map, as: TsMap

  def new() do
    countries =
      Map.merge(init_countries(), %{
        "syria" => {0, 1},
        "iraq" => {0, 1},
        "n_korea" => {0, 3},
        "e_germany" => {0, 3},
        "finland" => {0, 1},
        "cananda" => {2, 0},
        "iran" => {1, 0},
        "israel" => {1, 0},
        "japan" => {1, 0},
        "australia" => {4, 0},
        "philippines" => {1, 0},
        "s_korea" => {1, 0},
        "panama" => {1, 0},
        "south_africa" => {1, 0},
        "uk" => {5, 0}
      })

    early_war_cards = Ts.Game.Card.early_war_cards()

    %__MODULE__{
      countries: countries,
      status: :ussr_setup,
      usa_cards: Enum.slice(early_war_cards, 0..7),
      ussr_cards: Enum.slice(early_war_cards, 8..15),
      cards_in_deck: Enum.slice(early_war_cards, 16..-1)
    }
  end

  def init_countries do
    Enum.reduce(TsMap.countries(), %{}, fn {name, _}, acc ->
      Map.put(acc, name, {0, 0})
    end)
  end

  def ussr_setup_done(game, changes) do
    game =
      Enum.reduce(changes, game, fn {country, infl}, game ->
        {usa_influence, ussr_influence} = Map.get(game.countries, country)
        put_in(game.countries[country], {usa_influence, ussr_influence + infl})
      end)

    Map.merge(game, %{
      status: :usa_setup,
      phazing_player: :usa,
      current_player: [:usa],
      logs: [{:ussr_setup, changes}]
    })
  end

  def usa_setup_done(game, changes) do
    game =
      Enum.reduce(changes, game, fn {country, infl}, game ->
        {usa_influence, ussr_influence} = Map.get(game.countries, country)
        put_in(game.countries[country], {usa_influence + infl, ussr_influence})
      end)

    Map.merge(game, %{
      status: :headline_phase,
      current_player: [:usa, :ussr],
      logs: [{:usa_setup, changes} | game.logs]
    })
  end
end
