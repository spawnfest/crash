defmodule Crash.Build.Engine.Jobs.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: global_name(Node.self()))
  end

  def start_job(opts) do
    DynamicSupervisor.start_child(__MODULE__, {Crash.Build.Engine.Jobs.Instance, opts})
  end

  def start_remote_job(pid, opts) do
    DynamicSupervisor.start_child(pid, {Crash.Build.Engine.Jobs.Instance, opts})
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
