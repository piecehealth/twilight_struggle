defmodule Ts.Game.View do
  alias Ts.Game.Card
  alias Ts.Server.Room

  @empty_set MapSet.new([])

  def blank() do
    countries = Ts.Game.Game.init_countries()

    Map.merge(%Ts.Game.Game{}, %{
      countries: countries,
      countries_can_place_usa_influence: MapSet.new(Map.keys(countries)),
      countries_can_place_ussr_influence: MapSet.new(Map.keys(countries)),
      player_cards: [],
      cards_can_play: [],
      direction: :increase,
      selected_card: nil,
      user_actions: []
    })
  end

  def for(game, current_view, :usa) do
    {usa_avaliable_countries, total_point, max_point_limit} = get_usa_avaliable_countries(game)

    ussr_avaliable_countries =
      case game.status do
        _ -> @empty_set
      end

    direction =
      if game.status in [] do
        :reduce
      else
        :increase
      end

    game = Map.put(game, :player_cards, sorted_cards(game, :usa))

    Map.merge(game, %{
      usa_avaliable_countries: usa_avaliable_countries,
      countries_can_place_usa_influence: usa_avaliable_countries,
      countries_can_place_ussr_influence: ussr_avaliable_countries,
      total_point: total_point,
      remaining_point: total_point,
      max_point_limit: max_point_limit,
      influence_stack: [],
      cards_can_play: get_cards_can_play(game, :usa),
      direction: direction,
      selected_card: get_selected_card(game, current_view, :usa),
      user_actions: get_user_actions(game, current_view, :usa)
    })
  end

  def for(game, current_view, :ussr) do
    {ussr_avaliable_countries, total_point, max_point_limit} = get_ussr_avaliable_countries(game)

    usa_avaliable_countries =
      case game.status do
        _ -> @empty_set
      end

    direction =
      if game.status in [] do
        :reduce
      else
        :increase
      end

    game = Map.put(game, :player_cards, sorted_cards(game, :ussr))

    Map.merge(game, %{
      ussr_avaliable_countries: ussr_avaliable_countries,
      countries_can_place_usa_influence: usa_avaliable_countries,
      countries_can_place_ussr_influence: ussr_avaliable_countries,
      total_point: total_point,
      remaining_point: total_point,
      max_point_limit: max_point_limit,
      influence_stack: [],
      cards_can_play: get_cards_can_play(game, :ussr),
      direction: direction,
      selected_card: get_selected_card(game, current_view, :ussr),
      user_actions: get_user_actions(game, current_view, :ussr)
    })
  end

  @doc """
  Place influence to one contry.
  Could be triggered by event, or play card for placing influence.
  """
  def add_influence(game, side, country, place_influence \\ false) when side in [:usa, :ussr] do
    stable_point = Map.get(Ts.Game.Map.countries(), country) |> elem(2)
    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    game =
      if side == :usa do
        put_in(game.countries[country], {usa_influence + 1, ussr_influence})
      else
        put_in(game.countries[country], {usa_influence, ussr_influence + 1})
      end

    cost =
      if place_influence do
        if side == :usa do
          if ussr_influence - usa_influence >= stable_point, do: 2, else: 1
        else
          if usa_influence - ussr_influence >= stable_point, do: 2, else: 1
        end
      else
        1
      end

    game = Map.put(game, :remaining_point, game.remaining_point - cost)

    influence_stack = [{country, cost} | game.influence_stack]

    {key, countries_can_place_influence} =
      get_countries_can_place_influence(game, side, place_influence)

    user_actions =
      if MapSet.size(countries_can_place_influence) == 0 do
        ["undo", "commit"]
      else
        ["undo"]
      end

    Map.merge(game, %{
      influence_stack: influence_stack,
      user_actions: user_actions
    })
    |> Map.put(key, countries_can_place_influence)
  end

  def undo(game, _) do
    [{country, cost} | influence_stack] = game.influence_stack

    {usa_influence, ussr_influence} = Map.get(game.countries, country)

    side =
      cond do
        game.status in MapSet.new([:ussr_setup]) -> :ussr
        true -> :usa
      end

    place_influence =
      cond do
        game.status in MapSet.new([:place_influence]) -> true
        true -> false
      end

    cond do
      game.status in MapSet.new([:ussr_setup, :usa_setup]) ->
        game =
          if side == :usa do
            put_in(game.countries[country], {usa_influence - 1, ussr_influence})
          else
            put_in(game.countries[country], {usa_influence, ussr_influence - 1})
          end

        game = Map.put(game, :remaining_point, game.remaining_point + cost)

        user_actions =
          if game.remaining_point == game.total_point do
            []
          else
            ["undo"]
          end

        {key, countries_can_place_influence} =
          get_countries_can_place_influence(game, side, place_influence)

        Map.merge(game, %{
          influence_stack: influence_stack,
          user_actions: user_actions
        })
        |> Map.put(key, countries_can_place_influence)

      true ->
        game
    end
  end

  def commit(room_id, game, _) do
    case game.status do
      :ussr_setup ->
        changes =
          Enum.reduce(game.influence_stack, %{}, fn {country, _}, acc ->
            Map.update(acc, country, 1, &(&1 + 1))
          end)

        Room.perform_game_update(room_id, :ussr_setup_done, [changes])

      :usa_setup ->
        changes =
          Enum.reduce(game.influence_stack, %{}, fn {country, _}, acc ->
            Map.update(acc, country, 1, &(&1 + 1))
          end)

        Room.perform_game_update(room_id, :usa_setup_done, [changes])

      _ ->
        nil
    end
  end

  def play_headline_card(room_id, game, side) do
    Room.perform_game_update(room_id, :play_headline_card, [side, game.selected_card])
  end

  defp sorted_cards(game, side) when side in [:usa, :ussr] do
    {cards, order} =
      if side == :usa do
        {game.usa_cards, ["neutral", "ussr", "usa"]}
      else
        {game.ussr_cards, ["neutral", "usa", "ussr"]}
      end

    Enum.sort_by(
      cards,
      fn card ->
        %{op: op, belongs_to: belongs_to} = Map.get(Card.cards(), card)
        {Enum.find_index(order, &(&1 == belongs_to)), op}
      end,
      :desc
    )
  end

  defp get_ussr_avaliable_countries(game) do
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

        {east_europe_countries, 6, 6}

      _ ->
        {@empty_set, 0, 0}
    end
  end

  defp get_usa_avaliable_countries(game) do
    case game.status do
      :usa_setup ->
        west_europe_countries =
          MapSet.new([
            "cananda",
            "uk",
            "greece",
            "turkey",
            "italy",
            "austria",
            "finland",
            "sweden",
            "norway",
            "denmark",
            "w_germany",
            "benelux",
            "france",
            "spain_portugal"
          ])

        {west_europe_countries, 7, 7}

      _ ->
        {@empty_set, 0, 0}
    end
  end

  defp get_user_actions(game, current_view, side) when side in [:usa, :ussr] do
    case game.status do
      :headline_phase ->
        if Map.get(current_view, :user_actions) == [] do
          []
        else
          cond do
            game.memo && Map.get(game.memo, side) -> []
            current_view.status != :headline_phase -> []
            true -> Map.get(current_view, :user_actions) || []
          end
        end

      _ ->
        []
    end
  end

  defp get_countries_can_place_influence(game, side, place_influence) do
    remaining_point = game.remaining_point

    {key, avaliable_countries} =
      if side == :usa do
        {:countries_can_place_usa_influence, game.usa_avaliable_countries}
      else
        {:countries_can_place_ussr_influence, game.ussr_avaliable_countries}
      end

    countries_can_place_influence =
      if place_influence do
        Enum.filter(avaliable_countries, fn country ->
          {usa_inf, ussr_inf} = Map.get(game.countries, country)
          stable_point = Map.get(Ts.Game.Map.countries(), country) |> elem(2)

          cond do
            side == :usa && ussr_inf - usa_inf >= stable_point -> remaining_point >= 2
            side == :ussr && usa_inf - ussr_inf >= stable_point -> remaining_point >= 2
            true -> remaining_point >= 1
          end
        end)
      else
        if remaining_point == 0, do: @empty_set, else: avaliable_countries
      end

    {key, countries_can_place_influence}
  end

  defp get_cards_can_play(game, side) when side in [:usa, :ussr] do
    case game.status do
      :headline_phase ->
        game.player_cards

      _ ->
        []
    end
  end

  defp get_selected_card(game, current_view, side) when side in [:usa, :ussr] do
    case game.status do
      :headline_phase ->
        if Map.get(current_view, :selected_card) do
          if Map.get(game.memo, side) do
            nil
          else
            current_view.selected_card
          end
        else
          nil
        end

      _ ->
        nil
    end
  end
end
