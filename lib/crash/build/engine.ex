defmodule Crash.Build.Engine do
  @moduledoc false

  use GenServer

  require Logger

  alias Crash.Build.Engine.Jobs.Supervisor
  alias Crash.Core.Build
  alias Crash.Core.Pipeline
  alias Crash.Core.Repository

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{builds: []}, name: __MODULE__)
  end

  @doc """
  Fetch the single build of this engine
  """
  def info(build_id) do
    GenServer.call(__MODULE__, {:info, build_id})
  end

  @doc """
  Fetch the builds of this engine
  """
  def builds do
    GenServer.call(__MODULE__, :builds)
  end

  @doc false
  @impl GenServer
  def init(state) do
    Process.flag(:trap_exit, true)

    {:ok, state}
  end

  @doc false
  @impl GenServer
  def handle_call(:builds, _from, %{builds: builds} = state) do
    {:reply, builds, state}
  end

  @doc false
  @impl GenServer
  def handle_call({:schedule, pipeline, repository}, _from, %{builds: builds}) do
    build = generate_build(pipeline, repository)

    start_build(build)

    {:reply, build, %{builds: [build | builds]}}
  end

  def handle_call({:info, build_id}, _from, %{builds: builds} = state) do
    {:reply, Enum.find(builds, fn %Build{id: id} -> id == build_id end), state}
  end

  @doc false
  @impl GenServer
  def handle_info({:update, _pid, build_state}, %{builds: builds} = state) do
    case Enum.find_index(builds, fn %Build{id: id} -> id == build_state.build.id end) do
      nil ->
        {:noreply, state}

      index ->
        {:noreply, %{builds: List.replace_at(builds, index, build_state.build)}}
    end
  end

  def handle_info(msg, state) do
    Logger.error("#{__MODULE__} received unexpected message: #{inspect(msg)}")

    {:noreply, state}
  end

  @spec schedule(Pipeline.t(), Repository.t()) :: {:ok, Build.t()} | {:error, any}
  def schedule(%Pipeline{} = pipeline, %Repository{} = repository) do
    build = GenServer.call(__MODULE__, {:schedule, pipeline, repository})

    {:ok, build}
  end

  @spec status(String.t()) :: {:ok, Build.t()} | {:error, any}
  def status(build_id) do
    case :global.whereis_name(String.to_atom(build_id)) do
      pid when is_pid(pid) ->
        build = GenServer.call(pid, :status)
        {:ok, build}

      _ ->
        {:error, :build_not_found}
    end
  end

  defp generate_build(pipeline, repository) do
    build_id = UUID.uuid4()

    Build.new(%{
      id: build_id,
      pipeline: pipeline,
      state: :ready,
      completed_steps: [],
      repository: repository,
      started: Time.utc_now(),
      ended: nil
    })
  end

  defp start_build(build) do
    job_params = [build: build, process_uuid: :"#{build.id}", engine: self()]

    {:ok, _job} =
      case length(Node.list()) do
        0 ->
          pid = :global.whereis_name({Crash.Build.Engine.Jobs.Supervisor, Node.self()})

          Logger.info(
            "Start build #{build.id} on node #{inspect(Node.self())} with process #{inspect(pid)}"
          )

          Supervisor.start_remote_job(pid, job_params)

        _ ->
          node = [Node.self() | Node.list()] |> Enum.random()
          pid = :global.whereis_name({Crash.Build.Engine.Jobs.Supervisor, node})

          Logger.info(
            "Start build #{build.id} on node #{inspect(node)} with process #{inspect(pid)}"
          )

          Supervisor.start_remote_job(pid, job_params)
      end
  end
end
