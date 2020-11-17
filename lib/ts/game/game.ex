defmodule Ts.Game.Game do
  @not_start 0

  defstruct status: @not_start, contries: %{}, turn: 1, action_round: 1

  def new() do
    %__MODULE__{}
  end
end
