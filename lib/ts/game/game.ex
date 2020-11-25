defmodule Ts.Game.Game do
  defstruct status: :not_start,
            countries: %{},
            defcon_level: 5,
            phazing_player: :ussr,
            current_player: :ussr,
            turn: 1,
            action_round: 1,
            card_phaze: nil,
            card_choices: [],
            cards_in_deck: [],
            usa_cards: [],
            ussr_cards: [],
            player_cards: [],
            logs: [],
            buffs: MapSet.new(),
            can_add_usa_influence_countries: MapSet.new(),
            can_add_ussr_influence_countries: MapSet.new(),
            can_remove_usa_influence_countries: MapSet.new(),
            can_remove_ussr_influence_countries: MapSet.new(),
            total_point: 0,
            point_limit: 0

  alias Ts.Game.Map, as: TsMap
  alias Ts.Game.Card, as: Card

  def blank() do
    countries = init_countries()

    %__MODULE__{
      countries: init_countries(),
      can_add_usa_influence_countries: MapSet.new(Map.keys(countries)),
      can_add_ussr_influence_countries: MapSet.new(Map.keys(countries))
    }
  end

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

  def view_for(game = %__MODULE__{status: :not_start}, _), do: game

  def view_for(game, side) do
    case side do
      :usa ->
        order = ["neutral", "ussr", "usa"]

        cards =
          Enum.sort_by(
            game.usa_cards,
            fn card ->
              %{op: op, belongs_to: belongs_to} = Map.get(Card.cards(), card)
              {Enum.find_index(order, &(&1 == belongs_to)), op}
            end,
            :desc
          )

        Map.merge(game, %{player_cards: cards})

      :ussr ->
        order = ["neutral", "usa", "ussr"]

        cards =
          Enum.sort_by(
            game.ussr_cards,
            fn card ->
              %{op: op, belongs_to: belongs_to} = Map.get(Card.cards(), card)
              {Enum.find_index(order, &(&1 == belongs_to)), op}
            end,
            :desc
          )

        game = Map.put(game, :player_cards, cards)

        case game.status do
          :ussr_setup ->
            east_europe_countries =
              MapSet.new([
                "bulgaria",
                "yugoslavia",
                "romania",
                "hungray",
                "austria",
                "czechoslovakia",
                "poland",
                "finland",
                "e_germany"
              ])

            Map.merge(game, %{
              can_add_ussr_influence_countries: east_europe_countries,
              total_point: 6,
              point_limit: 6
            })

          _ ->
            game
        end

      _ ->
        game
    end
  end

  def init_countries do
    Enum.reduce(TsMap.countries(), %{}, fn {name, _}, acc ->
      Map.put(acc, name, {0, 0})
    end)
  end
end
