defmodule Ts.Game.Map do
  @bg "battle-ground"
  @normal "normal"

  # Regions
  @asia "asia"
  @s_asia "southeast-asia"

  @europe "europe"
  @w_europe "west-europe"
  @e_europe "east-europe"
  @m_europe "middle-europe"

  @c_america "central-america"
  @s_america "south-america"

  @middle_east "middle-east"

  @africa "africa"

  @countries %{
    # Asia
    "n_korea" => {@asia, @asia, 3, @bg, 960, 210},
    "s_korea" => {@asia, @asia, 3, @bg, 970, 245},
    "japan" => {@asia, @asia, 4, @bg, 1010, 275},
    "taiwan" => {@asia, @asia, 3, @normal, 955, 315},
    "philippines" => {@asia, @s_asia, 2, @normal, 975, 366},
    "indonesia" => {@asia, @s_asia, 1, @normal, 960, 456},
    "australia" => {@asia, @asia, 4, @normal, 960, 510},
    "malaysia" => {@asia, @s_asia, 2, @normal, 875, 415},
    "vietnam" => {@asia, @s_asia, 1, @normal, 903, 365},
    "thailand" => {@asia, @s_asia, 2, @bg, 848, 365},
    "laos_cambodia" => {@asia, @s_asia, 1, @normal, 875, 330},
    "burma" => {@asia, @s_asia, 2, @normal, 830, 325},
    "india" => {@asia, @asia, 3, @bg, 770, 320},
    "pakistan" => {@asia, @asia, 2, @bg, 718, 296},
    "afghanistan" => {@asia, @asia, 2, @normal, 718, 254},
    # Middle East
    "iran" => {@middle_east, @middle_east, 2, @bg, 662, 275},
    "iraq" => {@middle_east, @middle_east, 3, @bg, 613, 275},
    "israel" => {@middle_east, @middle_east, 4, @bg, 560, 275},
    "gulf_states" => {@middle_east, @middle_east, 3, @normal, 645, 310},
    "jordan" => {@middle_east, @middle_east, 2, @normal, 590, 310},
    "saudi_arabia" => {@middle_east, @middle_east, 3, @bg, 630, 342},
    "syria" => {@middle_east, @middle_east, 2, @normal, 614, 242},
    "lebanon" => {@middle_east, @middle_east, 1, @normal, 567, 243},
    "egypt" => {@middle_east, @middle_east, 2, @bg, 535, 309},
    "libya" => {@middle_east, @middle_east, 2, @bg, 485, 306},
    # Europe
    "cananda" => {@europe, @w_europe, 4, @normal, 170, 145},
    "uk" => {@europe, @w_europe, 5, @normal, 355, 105},
    "greece" => {@europe, @w_europe, 2, @normal, 507, 241},
    "turkey" => {@europe, @w_europe, 2, @normal, 594, 211},
    "italy" => {@europe, @w_europe, 2, @bg, 446, 207},
    "bulgaria" => {@europe, @e_europe, 3, @normal, 546, 207},
    "yugoslavia" => {@europe, @e_europe, 3, @normal, 496, 207},
    "romania" => {@europe, @e_europe, 3, @normal, 556, 172},
    "hungray" => {@europe, @e_europe, 3, @normal, 510, 172},
    "austria" => {@europe, @m_europe, 4, @normal, 460, 172},
    "czechoslovakia" => {@europe, @e_europe, 3, @normal, 500, 140},
    "poland" => {@europe, @e_europe, 3, @bg, 508, 108},
    "finland" => {@europe, @m_europe, 4, @normal, 537, 43},
    "sweden" => {@europe, @w_europe, 4, @normal, 472, 70},
    "norway" => {@europe, @w_europe, 4, @normal, 408, 40},
    "denmark" => {@europe, @w_europe, 3, @normal, 420, 75},
    "e_germany" => {@europe, @e_europe, 3, @bg, 456, 108},
    "w_germany" => {@europe, @w_europe, 4, @bg, 440, 140},
    "benelux" => {@europe, @w_europe, 3, @normal, 392, 140},
    "france" => {@europe, @w_europe, 3, @bg, 384, 180},
    "spain_portugal" => {@europe, @w_europe, 2, @normal, 350, 225},
    # Central America
    "mexico" => {@c_america, @c_america, 2, @bg, 28, 280},
    "guatemala" => {@c_america, @c_america, 1, @normal, 70, 314},
    "cuba" => {@c_america, @c_america, 3, @bg, 152, 304},
    "ei_salvador" => {@c_america, @c_america, 1, @normal, 54, 348},
    "honduras" => {@c_america, @c_america, 2, @normal, 100, 346},
    "nicaragua" => {@c_america, @c_america, 1, @normal, 150, 346},
    "haiti" => {@c_america, @c_america, 1, @normal, 200, 334},
    "dominican_rep" => {@c_america, @c_america, 1, @normal, 245, 334},
    "costa_rica" => {@c_america, @c_america, 3, @normal, 98, 380},
    "panama" => {@c_america, @c_america, 2, @bg, 150, 380},
    # South America
    "venezuela" => {@s_america, @s_america, 2, @bg, 208, 385},
    "colombia" => {@s_america, @s_america, 1, @normal, 180, 420},
    "ecuador" => {@s_america, @s_america, 2, @normal, 130, 435},
    "peru" => {@s_america, @s_america, 2, @normal, 158, 470},
    "brazil" => {@s_america, @s_america, 2, @bg, 292, 468},
    "bolivia" => {@s_america, @s_america, 2, @normal, 210, 500},
    "chile" => {@s_america, @s_america, 3, @bg, 180, 540},
    "paraguay" => {@s_america, @s_america, 2, @normal, 236, 536},
    "uruguay" => {@s_america, @s_america, 2, @normal, 250, 578},
    "argentina" => {@s_america, @s_america, 2, @bg, 198, 605},
    # Africa
    "morocco" => {@africa, @africa, 3, @normal, 360, 286},
    "algeria" => {@africa, @africa, 2, @bg, 410, 273},
    "tunisia" => {@africa, @africa, 2, @normal, 460, 269},
    "west_africa_states" => {@africa, @africa, 2, @normal, 358, 330},
    "saharan_states" => {@africa, @africa, 1, @normal, 430, 342},
    "sudan" => {@africa, @africa, 1, @normal, 545, 350},
    "ivory_coast" => {@africa, @africa, 2, @normal, 388, 394},
    "nigeria" => {@africa, @africa, 1, @bg, 448, 388},
    "ethiopia" => {@africa, @africa, 1, @normal, 580, 386},
    "cameroon" => {@africa, @africa, 1, @normal, 470, 425},
    "zaire" => {@africa, @africa, 1, @bg, 526, 442},
    "kenya" => {@africa, @africa, 2, @normal, 586, 430},
    "somalia" => {@africa, @africa, 2, @normal, 632, 400},
    "angola" => {@africa, @africa, 1, @bg, 486, 480},
    "east_africa_states" => {@africa, @africa, 1, @normal, 590, 472},
    "zimbabwe" => {@africa, @africa, 1, @normal, 545, 498},
    "botswana" => {@africa, @africa, 2, @normal, 528, 531},
    "south_africa" => {@africa, @africa, 3, @bg, 505, 567}
  }

  def countries, do: @countries
end
