defmodule TsWeb.GameView do
  use TsWeb, :view

  def fill_region(region) do
    case region do
      "asia" -> "rgb(242, 164, 30)"
      "middle-east" -> "rgb(199, 234, 254)"
      "west-europe" -> "rgb(163, 134, 190)"
      "east-europe" -> "rgb(187, 169, 211)"
      "central-america" -> "rgb(214, 220, 160)"
      "south-america" -> "rgb(160, 200, 135)"
      "africa" -> "rgb(254, 238, 170)"
      "middle-europe" -> "url('#middleEurope')"
      "southeast-asia" -> "url('#southeastEsia')"
      _ -> ""
    end
  end
end
