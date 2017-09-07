# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :achieve,
  ecto_repos: [Achieve.Repo]

# Configures the endpoint
config :achieve, Achieve.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0I1mwwXSjXeuEKrnaMRfxeJ9zqady+wMCIsj1p5VqVuj1Bq1vfOhnn1CJdGqzJel",
  render_errors: [view: Achieve.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Achieve.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user,public_repo,repo"] }
  ]

config :guardian, Guardian,
  allowed_algos: ["HS512", "HS384"],
  issuer: "Achieve",
  ttl: { 1, :days },
  serializer: Achieve.GuardianSerializer,
  secret_key: "lksjdlkjsdflkjsdf"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
