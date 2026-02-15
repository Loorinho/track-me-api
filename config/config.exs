# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :track_me_api,
  ecto_repos: [TrackMeApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configure the endpoint
config :track_me_api, TrackMeApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TrackMeApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TrackMeApi.PubSub,
  live_view: [signing_salt: "1y6Bzyq6"]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# setting up guardian
config :track_me_api, TrackMeApi.Auth.Guardian,
  issuer: "track_me_api",
  secret_key: "twC8DoqCJcU7GFMtYROFyDn9rBnHNj7k1zDrPBCnxy5EtJzVMvtsxbEQ7K5ObHU0"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
