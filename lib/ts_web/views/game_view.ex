defmodule TsWeb.GameView do
  use TsWeb, :view

  @countries [
    # Asia
    {"n_korea", "asia", 1650, 150, "battle-ground"},
    {"s_korea", "asia", 1650, 300, "battle-ground"},
    {"philippines", "asia", 1650, 500, "normal"}
  ]

  def countries() do
    @countries
  end
end
