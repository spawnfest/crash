defmodule Crash.Build.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children()
    |> Enum.map(&Supervisor.child_spec(&1, restart: :transient, shutdown: :timer.seconds(15)))
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp children do
    [
      Crash.Build.Engine,
      Crash.Build.Engine.Jobs.Supervisor
    ]
  end
end
