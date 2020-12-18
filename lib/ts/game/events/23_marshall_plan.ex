defmodule Ts.Game.Events.MarshallPlan do
  alias Ts.Game.Game

  def implement(game = %Game{buffs: buffs}) do
    buffs = MapSet.put(buffs, "marshall_plan")
    Map.put(game, :buffs, buffs)
  end

  def commited_infl_changes(game) do
    Ts.Game.Card.move_to_next_status(game)
  end
end
