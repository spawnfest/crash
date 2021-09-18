defmodule Crash.Application do
  @moduledoc false

  use Application

  @topologies Application.compile_env(:libcluster, :topologies)

  def start(_type, %{env: env}) do
    children = workers(env) ++ supervisors(env)

    opts = [strategy: :one_for_one, name: Crash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp workers(:test), do: workers(:*)

  defp workers(:dev),
    do: [
      {Plug.Cowboy, scheme: :http, plug: Crash.FakeServers.Github, options: [port: 4001]}
      | workers(:*)
    ]

  defp workers(_),
    do: [
      :poolboy.child_spec(:docker_worker, poolboy_config()),

      # Start the Telemetry supervisor
      CrashWeb.Telemetry,

      # Start the PubSub system
      {Phoenix.PubSub, name: Crash.PubSub},

      # Start the Endpoint (http/https)
      CrashWeb.Endpoint,

      # Start specialized Supervisor for Task
      {Task.Supervisor, name: Crash.TaskSupervisor}
    ]

  defp supervisors(:test), do: []
  defp supervisors(:dev), do: supervisors(:*)

  defp supervisors(_),
    do: [
      {Cluster.Supervisor, [@topologies, [name: Crash.ClusterSupervisor]]},
      Crash.Build.Supervisor
    ]

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CrashWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp poolboy_config do
    [
      name: {:local, :docker_worker},
      worker_module: Crash.Docker.Worker,
      size: 10,
      max_overflow: 1
    ]
  end
end
