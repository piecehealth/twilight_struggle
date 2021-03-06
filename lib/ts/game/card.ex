defmodule Ts.Game.Card do
  @callback avaliable_countries(map()) :: {MapSet.t(), integer(), integer()}
  @callback implement(map()) :: map()
  @callback get_user_actions(map()) :: {list(), list()}

  @early "early"
  @mid "mid"
  @late "late"

  @usa "usa"
  @ussr "ussr"
  @neutral "neutral"

  @cards %{
    # 4
    "duck_and_cover" => %{
      title: "duck_and_cover",
      belongs_to: @usa,
      stage: @early,
      op: 3,
      is_asterisk: false,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 5
    "five_years_plan" => %{
      title: "five_years_plan",
      belongs_to: @usa,
      stage: @early,
      op: 3,
      is_asterisk: false,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 6 The China Card
    # 7
    "socialist_governments" => %{
      title: "socialist_governments",
      belongs_to: @ussr,
      stage: @early,
      op: 3,
      is_asterisk: false,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 8
    "fidel" => %{
      title: "fidel",
      belongs_to: @ussr,
      stage: @early,
      op: 2,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 9
    "vietnam_revolts" => %{
      title: "vietnam_revolts",
      belongs_to: @ussr,
      stage: @early,
      op: 2,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 10
    "blockade" => %{
      title: "blockade",
      belongs_to: @ussr,
      stage: @early,
      op: 1,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 11
    "korean_war" => %{
      title: "korean_war",
      belongs_to: @ussr,
      stage: @early,
      op: 2,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 12
    "romanian_abdication" => %{
      title: "romanian_abdication",
      belongs_to: @ussr,
      stage: @early,
      op: 1,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 13
    "arab_israeli_war" => %{
      title: "arab_israeli_war",
      belongs_to: @ussr,
      stage: @early,
      op: 2,
      is_asterisk: false,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 14
    "comecon" => %{
      title: "comecon",
      belongs_to: @ussr,
      stage: @early,
      op: 3,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 15
    "nasser" => %{
      title: "nasser",
      belongs_to: @ussr,
      stage: @early,
      op: 1,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 16
    "warsaw_pack_formed" => %{
      title: "warsaw_pack_formed",
      belongs_to: @ussr,
      stage: @early,
      op: 3,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 17
    "de_gaulle_leads_france" => %{
      title: "de_gaulle_leads_france",
      belongs_to: @ussr,
      stage: @early,
      op: 3,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 18
    "caputred_nazi_scientist" => %{
      title: "caputred_nazi_scientist",
      belongs_to: @neutral,
      stage: @early,
      op: 1,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 19
    "truman_doctrine" => %{
      title: "truman_doctrine",
      belongs_to: @usa,
      stage: @early,
      op: 1,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 20
    "olympic_games" => %{
      title: "olympic_games",
      belongs_to: @neutral,
      stage: @early,
      op: 2,
      is_asterisk: false,
      is_score: false,
      event: Ts.Game.Events.DuckAndCover
    },
    # 23
    "marshall_plan" => %{
      title: "marshall_plan",
      belongs_to: @usa,
      stage: @early,
      op: 4,
      is_asterisk: true,
      is_score: false,
      event: Ts.Game.Events.MarshallPlan
    }
  }

  def cards do
    @cards
  end

  def early_war_cards do
    @cards
    |> Map.values()
    |> Enum.filter(fn %{stage: stage} -> stage == @early end)
    |> Enum.map(&Map.get(&1, :title))
    |> Enum.shuffle()
  end

  def move_to_next_status(game = %{current_card: current_card, current_player: [current_player]}) do
    case game.status do
      :perform_headline_phase_1 ->
        next_card_id = Map.values(game.memo) |> List.delete(current_card) |> Enum.at(0)

        next_card = Map.get(@cards, next_card_id)

        next_player =
          if next_card.belongs_to == @neutral do
            if current_player == :usa, do: :ussr, else: :usa
          else
            String.to_atom(next_card.belongs_to)
          end

        game =
          Map.merge(game, %{
            status: :perform_headline_phase_2,
            current_player: [next_player],
            current_card: next_card_id
          })

        apply(next_card.event, :implement, [game])

      :perform_headline_phase_2 ->
        Map.merge(game, %{
          status: :action_round,
          current_player: [:ussr],
          current_card: nil
        })

      :action_round ->
        # TODO
        game

      _ ->
        game
    end
  end
end
