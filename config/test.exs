use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :devito, DevitoWeb.Endpoint,
  http: [port: 4002],
  server: false

config :devito, table_name: :test_data
# Print only warnings and errors during test
config :logger, level: :warn
