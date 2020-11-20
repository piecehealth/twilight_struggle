defmodule Ts.Game.Game do
  defstruct status: :not_start,
            countries: %{},
            turn: 1,
            action_round: 1,
            can_add_usa_influence_countries: MapSet.new(),
            can_add_ussr_influence_countries: MapSet.new(),
            can_remove_usa_influence_countries: MapSet.new(),
            can_remove_ussr_influence_countries: MapSet.new()

  alias Ts.Game.Map, as: TsMap

  def blank() do
    %__MODULE__{
      countries: init_countries()
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

    %__MODULE__{
      countries: countries,
      status: :ussr_setup
    }
  end

  def game_view_for(game, _side) do
    game
  end

  def init_countries do
    Enum.reduce(TsMap.countries(), %{}, fn {name, _}, acc ->
      Map.put(acc, name, {0, 0})
    end)
  end
end
