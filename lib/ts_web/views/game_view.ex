defmodule TsWeb.GameView do
  use TsWeb, :view

  alias Ts.Server.Room

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

  def influence_class(usa_inf, ussr_inf, stable_point, side) do
    case side do
      "usa" ->
        if usa_inf - ussr_inf >= stable_point do
          "usa-control"
        else
          "usa-presence"
        end

      "ussr" ->
        if ussr_inf - usa_inf >= stable_point do
          "ussr-control"
        else
          "ussr-presence"
        end
    end
  end

  def op_class(belongs_to) do
    case belongs_to do
      "usa" -> "card-op-usa"
      "ussr" -> "card-op-ussr"
      _ -> "card-op-neutral"
    end
  end

  def stage_class(stage) do
    case stage do
      "early" -> "card-stage-early"
      _ -> ""
    end
  end

  def which_side(room, user_id) do
    cond do
      Room.usa_player?(room, user_id) -> "usa"
      Room.ussr_player?(room, user_id) -> "ussr"
      true -> ""
    end
  end
end
