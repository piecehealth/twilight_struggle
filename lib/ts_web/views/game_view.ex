defmodule TsWeb.GameView do
  use TsWeb, :view

  def fill_region(region) do
    case region do
      "asia" -> "rgb(242, 164, 30)"
      "middle-east" -> "rgb(199, 234, 254)"
      "southeast-asia" -> "url('#southeastEsia')"
      _ -> ""
    end
  end
end
