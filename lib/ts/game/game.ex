defmodule Ts.Game.Game do
  @not_start 0

  defstruct room_id: nil, status: @not_start, contries: %{}, round: 1

  def new() do
    %__MODULE__{}
  end
end
