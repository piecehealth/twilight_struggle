defmodule Ts.Server.GameSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      Ts.Server.RoomAgent,
      Ts.Server.RoomManager
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
