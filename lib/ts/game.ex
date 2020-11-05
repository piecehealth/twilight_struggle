defmodule Ts.Game do
  @bg "battle-ground"
  @normal "normal"

  @asia "asia"
  @s_asia "southeast-asia"

  @middle_east "middle-east"

  @map %{
    # Asia
    "n_korea" => {@asia, @asia, 3, @bg, 2170, 400},
    "s_korea" => {@asia, @asia, 3, @bg, 2200, 500},
    "japan" => {@asia, @asia, 4, @bg, 2300, 600},
    "taiwan" => {@asia, @asia, 3, @normal, 2150, 700},
    "philippines" => {@asia, @s_asia, 2, @normal, 2200, 850},
    "indonesia" => {@asia, @s_asia, 1, @normal, 2170, 1070},
    "australia" => {@asia, @asia, 4, @normal, 2170, 1250},
    "malaysia" => {@asia, @s_asia, 2, @normal, 1900, 960},
    "vietnam" => {@asia, @s_asia, 1, @normal, 1980, 850},
    "thailand" => {@asia, @s_asia, 2, @bg, 1840, 850},
    "laos_cambodia" => {@asia, @s_asia, 1, @normal, 1900, 750},
    "burma" => {@asia, @s_asia, 2, @normal, 1760, 730},
    "india" => {@asia, @asia, 3, @bg, 1590, 710},
    "pakistan" => {@asia, @asia, 2, @bg, 1440, 650},
    "afghanistan" => {@asia, @asia, 2, @normal, 1440, 550},
    # Middle East
    "iran" => {@middle_east, @middle_east, 2, @bg, 1270, 610},
    "iraq" => {@middle_east, @middle_east, 3, @bg, 1130, 610},
    "israel" => {@middle_east, @middle_east, 4, @bg, 980, 610},
    "gulf_states" => {@middle_east, @middle_east, 3, @normal, 1210, 710},
    "jordan" => {@middle_east, @middle_east, 2, @normal, 1050, 710},
    "saudi_arabia" => {@middle_east, @middle_east, 3, @bg, 1180, 810},
    "syria" => {@middle_east, @middle_east, 2, @normal, 1140, 510},
    "lebanon" => {@middle_east, @middle_east, 1, @normal, 1000, 510},
    "egypt" => {@middle_east, @middle_east, 2, @bg, 900, 710},
    "libya" => {@middle_east, @middle_east, 2, @bg, 760, 690}
  }

  def map, do: @map
end
