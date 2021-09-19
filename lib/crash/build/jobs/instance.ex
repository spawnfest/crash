defmodule Crash.Build.Engine.Jobs.Instance do
  @moduledoc false

  use GenServer, restart: :temporary

  require Logger

  alias Crash.Core.Build
  alias Crash.Core.Pipeline
  alias Crash.Docker.Containers
  alias Crash.Docker.Images
  alias Crash.Docker.Volumes
  alias Crash.Support.Ansi
  alias Crash.Support.Data

  defmodule State do
    @moduledoc false

    @derive Jason.Encoder
    defstruct [
      :process_uuid,
      :build,
      :engine,
      :volume
    ]
  end

  @doc """
  Stop the given process job instance, typically called when it has reached its final state
  """
  def stop(instance) do
    GenServer.call(instance, :stop)
  end

  @doc """
  Fetch the process status of this instance
  """
  def job_status(instance) do
    GenServer.call(instance, :status)
  end

  def start_link(opts) do
    {:ok, %Tesla.Env{body: volume}} = Volumes.create()

    state = %State{
      process_uuid: Keyword.fetch!(opts, :process_uuid),
      build: Keyword.fetch!(opts, :build),
      engine: Keyword.fetch!(opts, :engine),
      volume: Data.atomize_keys(volume)
    }

    GenServer.start_link(__MODULE__, state, name: {:global, state.process_uuid})
  end

  @doc false
  @impl GenServer
  def init(%State{} = state) do
    Process.flag(:trap_exit, true)

    {:ok, state, {:continue, :define_state}}
  end

  @doc false
  @impl GenServer
  def handle_continue(:define_state, %State{process_uuid: process_uuid} = state) do
    Process.put(:process_uuid, process_uuid)

    schedule_job()

    {:noreply, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:status, _from, %State{build: build} = state) do
    {:reply, {:ok, build}, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:stop, _from, %State{} = state) do
    {:stop, :normal, :ok, state}
  end

  defp stop_build(%State{build: build} = build_state) do
    Logger.info("Stop #{inspect(__MODULE__)} for #{inspect(build.id)}...")

    new_build = %{build | ended: DateTime.utc_now(), state: :finished}
    %{build_state | build: new_build}
  end

  @impl true
  def handle_info(:stop_job, %State{engine: engine} = build_state) do
    new_state = stop_build(build_state)

    send(engine, {:update, self(), new_state})

    {:stop, :normal, new_state}
  end

  @impl true
  def handle_info(
        :run,
        %State{build: %Build{pipeline: %Pipeline{steps: []}}, engine: engine} = build_state
      ) do
    new_state = stop_build(build_state)

    send(engine, {:update, self(), new_state})

    {:stop, :normal, new_state}
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
          volume: %{Name: name}
        } = state
      ) do
    Logger.info("Start #{inspect(__MODULE__)} for #{inspect(build.id)}...")

    _image = Images.pull(step.image)

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

    _container = Containers.start(id)

    {_, status} = exited(id)

    {:ok, %Tesla.Env{body: body}} = Containers.logs(id)

    logs = body |> String.split("\r\n") |> Enum.map(&Ansi.strip/1)

    new_pipeline = struct(pipeline, steps: steps)

    new_build =
      struct(build,
        pipeline: new_pipeline,
        completed_steps: completed_steps ++ [%{step | logs: logs, result: status}],
        status: :running
      )

    new_state = struct(state, build: new_build)

    if status == :success do
      schedule_job()
    else
      stop_job()
    end

    {:noreply, new_state}
  end

  defp schedule_job(run_in_millis \\ 0) do
    Process.send_after(self(), :run, run_in_millis)

    :ok
  end

  defp stop_job(run_in_millis \\ 0) do
    Process.send_after(self(), :stop_job, run_in_millis)

    :ok
  end

  defp exited(container_id) do
    {:ok, %Tesla.Env{body: body}} = Containers.status(container_id)

    case body do
      %{"State" => %{"Status" => "running"}} ->
        Process.sleep(100)
        exited(container_id)

      %{"State" => %{"Status" => "exited", "Dead" => false, "Error" => "", "ExitCode" => 0}} ->
        {:ok, :success}

      _ ->
        {:ok, :error}
    end
  end
end
