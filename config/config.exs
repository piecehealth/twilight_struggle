# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ts, TsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "i3et0pfnOOj02u1y1mMQiHm5yAnhmzKJFClOFU844FpkLK7FiQXF6SGIODMeqkK/",
  render_errors: [view: TsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ts.PubSub,
  live_view: [signing_salt: "F3Lb5gUM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
