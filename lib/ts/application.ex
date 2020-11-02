defmodule Ts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ts.PubSub},
      # Start the Endpoint (http/https)
      TsWeb.Endpoint
      # Start a worker by calling: Ts.Worker.start_link(arg)
      # {Ts.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
