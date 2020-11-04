defmodule Ts.Game do
  @map %{
    # Asia
    "n_korea" => {"asia", "asia", 3, "battle-ground", 1650, 150},
    "s_korea" => {"asia", "asia", 3, "battle-ground", 1650, 300},
    "japan" => {"asia", "asia", 4, "battle-ground", 1800, 450},
    "philippines" => {"asia", "southeast-asia", 2, "normal", 1650, 500}
  }

  def map, do: @map
end
