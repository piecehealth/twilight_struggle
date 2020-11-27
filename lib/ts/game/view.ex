defmodule Ts.Game.View do
  alias Ts.Game.Card

  @empty_set MapSet.new([])

  def blank() do
    countries = Ts.Game.Game.init_countries()

    Map.merge(%Ts.Game.Game{}, %{
      countries: countries,
      countries_can_place_usa_influence: MapSet.new(Map.keys(countries)),
      countries_can_place_ussr_influence: MapSet.new(Map.keys(countries)),
      player_cards: [],
      direction: :increase,
      user_actions: []
    })
  end

  def for(game, :usa) do
    Map.merge(game, %{
      countries_can_place_usa_influence: @empty_set,
      countries_can_place_ussr_influence: @empty_set,
      player_cards: sorted_cards(game, :usa),
      direction: :increase,
      user_actions: []
    })
  end

  def for(game, :ussr) do
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

    Map.merge(game, %{
      ussr_avaliable_countries: ussr_avaliable_countries,
      countries_can_place_usa_influence: usa_avaliable_countries,
      countries_can_place_ussr_influence: ussr_avaliable_countries,
      player_cards: sorted_cards(game, :ussr),
      total_point: total_point,
      remaining_point: total_point,
      max_point_limit: max_point_limit,
      influence_stack: [],
      direction: direction,
      user_actions: get_user_actions(game, :ussr)
    })
  end

  def add_influence(game, side, country, place_influence \\ false) when side in [:usa, :ussr] do
    stable_point = Map.get(Ts.Game.Map.countries(), country) |> elem(2)
    {usa_influence, ussr_influence} = Map.get(game.countries, country)
    game = put_in(game.countries[country], {usa_influence, ussr_influence + 1})

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

    remaining_point = game.remaining_point - cost

    influence_stack = [{country, cost}, game.influence_stack]

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
        if remaining_point == 0, do: @empty_set, else: game.ussr_avaliable_countries
      end

    user_actions =
      if MapSet.size(countries_can_place_influence) == 0 do
        ["undo", "commit"]
      else
        ["undo"]
      end

    Map.merge(game, %{
      remaining_point: remaining_point,
      influence_stack: influence_stack,
      user_actions: user_actions
    })
    |> Map.put(key, countries_can_place_influence)
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

  defp get_user_actions(game, side) when side in [:usa, :ussr] do
    case game.status do
      _ -> []
    end
  end
end
