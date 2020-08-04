# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :devito, Devito.Repo,
  database: "devito_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

# Configures the endpoint
config :devito, DevitoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GePz9gvE9FSE1vpYauQ2rI/83JtnDIA5Woasr0ks0m672UWMc4RNo48Uok4yarhT",
  render_errors: [view: DevitoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Devito.PubSub,
  live_view: [signing_salt: "ijUPEiX2"]

config :devito,
  short_code_chars:
    Enum.map(?A..?Z, &<<&1>>) ++ Enum.map(?a..?z, &<<&1>>) ++ Enum.map(?0..?9, &<<&1>>)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
