defmodule Ts.Game do
  @bg "battle-ground"
  @normal "normal"

  @map %{
    # Asia
    "n_korea" => {"asia", "asia", 3, @bg, 2170, 200},
    "s_korea" => {"asia", "asia", 3, @bg, 2200, 300},
    "japan" => {"asia", "asia", 4, @bg, 2300, 400},
    "taiwan" => {"asia", "asia", 3, @normal, 2150, 500},
    "philippines" => {"asia", "southeast-asia", 2, @normal, 2200, 650},
    "indonesia" => {"asia", "southeast-asia", 1, @normal, 2170, 870},
    "australia" => {"asia", "asia", 4, @normal, 2170, 1000},
    "malaysia" => {"asia", "southeast-asia", 2, @normal, 1900, 760},
    "vietnam" => {"asia", "southeast-asia", 1, @normal, 1980, 650},
    "thailand" => {"asia", "southeast-asia", 2, @bg, 1840, 650},
    "laos_cambodia" => {"asia", "southeast-asia", 1, @normal, 1900, 550},
    "burma" => {"asia", "southeast-asia", 2, @normal, 1760, 530},
    "india" => {"asia", "asia", 3, @bg, 1590, 510},
    "pakistan" => {"asia", "asia", 2, @bg, 1440, 450},
    "afghanistan" => {"asia", "asia", 2, @normal, 1440, 350}
  }

  def map, do: @map
end
