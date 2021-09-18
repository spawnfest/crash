# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :crash, CrashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oJMr+Z+HryZIpYtEG1Tu9gago8jKKsRXU6FCoCTxq2E56FZPENTo/vE0Tq3gVIrt",
  render_errors: [view: CrashWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Crash.PubSub,
  live_view: [signing_salt: "bkGOCi+o"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :tesla, Tesla.Middleware.Logger, debug: false

config :crash, :docker,
  protocol: "http+unix",
  host: "/var/run/docker.sock",
  version: "v1.18"

config :crash, :github, base_url: "http://localhost:4001"

config :libcluster,
  topologies: [
    example: [
      # The selected clustering strategy. Required.
      strategy: Cluster.Strategy.Epmd,
      # Configuration for the provided strategy. Optional.
      config: [hosts: []],
      # The function to use for connecting nodes. The node
      # name will be appended to the argument list. Optional
      connect: {:net_kernel, :connect_node, []},
      # The function to use for disconnecting nodes. The node
      # name will be appended to the argument list. Optional
      disconnect: {:erlang, :disconnect_node, []},
      # The function to use for listing nodes.
      # This function must return a list of node names. Optional
      list_nodes: {:erlang, :nodes, [:connected]}
    ]
  ]

import_config "#{Mix.env()}.exs"
