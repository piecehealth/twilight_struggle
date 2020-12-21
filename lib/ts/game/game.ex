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
            buffs: MapSet.new(),
            memo: nil

  alias Ts.Game.Map, as: TsMap
  alias Ts.Game.Card

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

  def commit_infl_changes_for_card(game = %{current_card: current_card}, changes) do
    [current_player] = game.current_player

    game =
      cond do
        current_player == :usa ->
          Enum.reduce(changes, game, fn {country, infl}, game ->
            {usa_influence, ussr_influence} = Map.get(game.countries, country)
            put_in(game.countries[country], {usa_influence + infl, ussr_influence})
          end)

        current_player == :ussr ->
          Enum.reduce(changes, game, fn {country, infl}, game ->
            {usa_influence, ussr_influence} = Map.get(game.countries, country)
            put_in(game.countries[country], {usa_influence, ussr_influence + infl})
          end)

        true ->
          game
      end

    card_event = Map.get(Card.cards(), current_card).event

    note = (Atom.to_string(current_player) <> "_put_infl") |> String.to_atom()

    Map.put(game, :logs, [{note, changes} | game.logs])

    apply(card_event, :commited_infl_changes, [game])
  end

  def play_headline_card(%Ts.Game.Game{memo: nil} = game, side, card)
      when side in [:usa, :ussr] do
    Map.put(game, :memo, Map.put(%{}, side, card))
  end

  def play_headline_card(game, side, card)
      when side in [:usa, :ussr] do
    opponent_side = if side == :usa, do: :ussr, else: :usa

    if Map.get(game.memo, opponent_side) do
      game = put_in(game.memo[side], card)
      %{usa: usa_card_id, ussr: ussr_card_id} = game.memo

      usa_card = Map.get(Card.cards(), usa_card_id)
      ussr_card = Map.get(Card.cards(), ussr_card_id)

      {phazing_player, current_player, current_card} =
        if usa_card.op >= ussr_card.op do
          card_player =
            if usa_card.belongs_to == "neutral",
              do: :usa,
              else: String.to_atom(usa_card.belongs_to)

          {:usa, card_player, usa_card}
        else
          card_player =
            if ussr_card.belongs_to == "neutral",
              do: :ussr,
              else: String.to_atom(ussr_card.belongs_to)

          {:ussr, card_player, ussr_card}
        end

      game =
        Map.merge(game, %{
          status: :perform_headline_phase_1,
          phazing_player: phazing_player,
          current_player: [current_player],
          usa_cards: List.delete(game.usa_cards, game.memo.usa),
          ussr_cards: List.delete(game.ussr_cards, game.memo.ussr),
          current_card: current_card.title,
          logs: [{:headline_phase, game.memo} | game.logs]
        })

      apply(current_card.event, :implement, [game])
    else
      put_in(game.memo[side], card)
    end
  end

  def perform_card_action(game = %{current_card: current_card}, side, action) do
    card_event = Map.get(Card.cards(), current_card).event
    apply(card_event, action, [game, side])
  end
end
