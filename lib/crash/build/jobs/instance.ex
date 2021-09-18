defmodule Crash.Build.Engine.Jobs.Instance do
  @moduledoc false

  use GenServer, restart: :temporary

  require Logger

  alias Crash.Core.Build
  alias Crash.Core.Pipeline
  alias Crash.Docker.Containers
  alias Crash.Docker.Images
  alias Crash.Docker.Volumes

  defmodule State do
    @moduledoc false

    @derive Jason.Encoder
    defstruct [
      :process_uuid,
      :build,
      :engine,
      :volume,
      :logs
    ]
  end

  def start_link(opts) do
    {:ok, %Tesla.Env{body: volume}} = Volumes.create()

    state = %State{
      process_uuid: Keyword.fetch!(opts, :process_uuid),
      build: Keyword.fetch!(opts, :build),
      engine: Keyword.fetch!(opts, :engine),
      volume: volume,
      logs: %{}
    }

    GenServer.start_link(__MODULE__, state, name: state.process_uuid)
  end

  @doc """
  Stop the given process job instance.

  Typically called when it has reached its final state.
  """
  def stop(instance) do
    GenServer.call(instance, :stop)
  end

  @doc """
  Get the current job instance's identity.
  """
  def identity, do: Process.get(:process_uuid)

  @doc """
  Fetch the process state of this instance
  """
  def job_state(instance) do
    GenServer.call(instance, :job_state)
  end

  @doc false
  @impl GenServer
  def init(%State{} = state) do
    Process.flag(:trap_exit, true)
    {:ok, state, {:continue, :define_state}}
  end

  @doc false
  @impl GenServer
  def handle_continue(:define_state, %State{} = state) do
    %State{process_uuid: process_uuid} = state

    Process.put(:process_uuid, process_uuid)

    schedule_job()

    {:noreply, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:status, _from, %State{build: build} = state) do
    {:reply, build, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:job_state, _from, %State{build: build} = state) do
    {:reply, build, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:stop, _from, %State{} = state) do
    # Stop the process with a normal reason
    {:stop, :normal, :ok, state}
  end

  @impl true
  def handle_info(
        :run,
        %State{build: %Build{pipeline: %Pipeline{steps: []}} = state, engine: engine} =
          build_state
      ) do
    Logger.info("Stop #{inspect(__MODULE__)}... #{inspect(state)}")

    send(engine, {:update, self(), build_state})

    {:stop, :normal, state}
  end

  @impl true
  def handle_info(
        :run,
        %State{
          build:
            %Build{
              pipeline: %Pipeline{steps: [step | steps]} = pipeline,
              completed_steps: completed_steps
            } = build,
          volume: %{"Name" => name},
          logs: logs
        } = state
      ) do
    Logger.info("Start #{inspect(__MODULE__)}...")

    _a = Images.pull(step.image)

    cmds = Enum.join(step.commands, ";")

    {:ok, %Tesla.Env{body: %{"Id" => id}}} =
      Containers.create(%{
        Image: step.image,
        Tty: true,
        Labels: %{Crash: ""},
        Entrypoint: ["/bin/sh", "-c"],
        Cmd: ["echo \"$SCRIPT\" | /bin/sh"],
        Env: ["SCRIPT= set -ex; #{cmds}"],
        WorkingDir: "/app",
        HostConfig: %{Binds: ["#{name}:/app"]}
      })

    _c = Containers.start(id)

    _d = exited?(id)

    {:ok, %Tesla.Env{body: body}} = Containers.logs(id)

    a_logs = body |> String.split("\r\n")

    new_p = struct(pipeline, steps: steps)

    new_b = struct(build, pipeline: new_p, completed_steps: completed_steps ++ [step])

    new_s = struct(state, build: new_b, logs: Map.merge(logs, %{:"step.name" => a_logs}))

    schedule_job()

    {:noreply, new_s}
  end

  defp schedule_job(run_in_millis \\ 0) do
    Process.send_after(self(), :run, run_in_millis)
    :ok
  end

  defp exited?(container_id) do
    {:ok, %Tesla.Env{body: body}} = Containers.status(container_id)

    case body do
      %{"State" => %{"Status" => "running"}} ->
        Process.sleep(500)
        exited?(container_id)

      _ ->
        true
    end
  end
end
