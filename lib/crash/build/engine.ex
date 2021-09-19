defmodule Crash.Build.Engine do
  @moduledoc false

  use GenServer

  require Logger

  alias Crash.Build.Engine.Jobs.Instance
  alias Crash.Build.Engine.Jobs.Supervisor
  alias Crash.Core.Build
  alias Crash.Core.Pipeline
  alias Crash.Core.Repository

  @doc """
  Fetch the single build from engine state
  """
  @spec info(String.t()) :: Build.t() | nil
  def info(build_id) do
    GenServer.call(__MODULE__, {:info, build_id})
  end

  @doc """
  Fetch the builds from engine state
  """
  @spec builds :: [Build.t()]
  def builds do
    GenServer.call(__MODULE__, :builds)
  end

  @doc """
  Schedule a build from pipeline and repository
  """
  @spec schedule(Pipeline.t(), Repository.t()) :: {:ok, Build.t()} | {:error, term()}
  def schedule(%Pipeline{} = pipeline, %Repository{} = repository) do
    GenServer.call(__MODULE__, {:schedule, pipeline, repository})
  end

  @doc """
  Fetch the single build of this engine directly from the instance process
  """
  @spec status(String.t()) :: {:ok, Build.t()} | {:error, term()}
  def status(build_id) do
    case :global.whereis_name(String.to_atom(build_id)) do
      pid when is_pid(pid) ->
        Instance.job_status(pid)

      _ ->
        {:error, :build_not_found}
    end
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{builds: []}, name: __MODULE__)
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
  def handle_call({:schedule, pipeline, repository}, _from, %{builds: builds} = state) do
    build = generate_build(pipeline, repository)

    case start_build(build) do
      {:ok, _pid} ->
        {:reply, {:ok, build}, %{builds: [build | builds]}}

      {:error, {:already_started, _pid}} ->
        {:reply, {:ok, build}, state}

      _ ->
        {:reply, {:error, :not_started}, state}
    end
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

  defp generate_build(pipeline, repository) do
    Build.new(%{
      id: UUID.uuid4(),
      pipeline: pipeline,
      state: :ready,
      completed_steps: [],
      repository: repository,
      started: DateTime.utc_now(),
      ended: nil
    })
  end

  defp start_build(build) do
    {pid, node} = fetch_supervisor_process()

    Logger.info(fn ->
      "Start build #{build.id} on node #{inspect(node)} with process #{inspect(pid)}"
    end)

    Supervisor.start_remote_job(pid, build: build, process_uuid: :"#{build.id}", engine: self())
  end

  defp fetch_supervisor_process do
    case length(Node.list()) do
      0 ->
        {:global.whereis_name({Supervisor, Node.self()}), Node.self()}

      _ ->
        node = [Node.self() | Node.list()] |> Enum.random()
        pid = :global.whereis_name({Supervisor, node})

        {pid, node}
    end
  end
end
