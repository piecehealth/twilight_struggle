defmodule Ts.Game.Game do
  defstruct status: :not_start,
            countries: %{},
            usa_actionable_countries: %{},
            ussr_actionable_countries: %{},
            turn: 1,
            action_round: 1

  alias Ts.Game.Map, as: TsMap

  def new() do
    %__MODULE__{}
  end

  def blank() do
    countries = init_countries()

    %__MODULE__{
      status: :blank,
      countries: countries
    }
  end

  def init_countries do
    Enum.reduce(TsMap.countries(), %{}, fn {name, _}, acc ->
      Map.put(acc, name, {0, 0})
    end)
  end
end
