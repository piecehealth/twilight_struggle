defmodule Ts.Game.Events.DuckAndCover do
  @behaviour Ts.Game.Card

  @impl true
  def implement(game) do
    game
  end

  @impl true
  def avaliable_countries(_game) do
    {MapSet.new([]), 0, 0}
  end

  @impl true
  def get_user_actions(_game) do
    {["skip"], ["skip"]}
  end

  def skip(game, _side) do
    Ts.Game.Card.move_to_next_status(game)
  end
end
