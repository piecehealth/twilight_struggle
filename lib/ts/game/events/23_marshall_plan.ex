defmodule Ts.Game.Events.MarshallPlan do
  @behaviour Ts.Game.Card

  alias Ts.Game.Game

  @impl true
  def implement(game = %Game{buffs: buffs}) do
    buffs = MapSet.put(buffs, "marshall_plan")
    Map.put(game, :buffs, buffs)
  end

  @impl true
  def avaliable_countries(_game) do
    {MapSet.new([
       "cananda",
       "uk",
       "greece",
       "turkey",
       "italy",
       "austria",
       "finland",
       "sweden",
       "norway",
       "denmark",
       "w_germany",
       "benelux",
       "france",
       "spain_portugal"
     ]), 7, 1}
  end

  @impl true
  def get_user_actions(_game) do
    {[], []}
  end

  def commited_infl_changes(game) do
    Ts.Game.Card.move_to_next_status(game)
  end
end
