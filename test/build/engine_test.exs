defmodule Crash.Build.EngineTest do
  @moduledoc false

  use ExUnit.Case

  import Mock

  alias Crash.Build.Engine
  alias Crash.Build.Engine.Jobs.Supervisor
  alias CrashWeb.Builders.PipelineBuilder
  alias CrashWeb.Builders.RepositoryBuilder

  describe "start_link/1" do
    test "can start Engine process with no ops" do
      assert {:ok, _pid} = Engine.start_link(%{})
    end
  end

  describe "schedule/1" do
    test "can schedule a build with an existing Engine" do
      with_mock Supervisor, start_remote_job: fn _, _ -> {:ok, :c.pid(0, 250, 0)} end do
        start_supervised!(Engine)

        pipeline = PipelineBuilder.build()
        repository = RepositoryBuilder.build()

        assert {:ok, _build} = Engine.schedule(pipeline, repository)
      end
    end
  end
end
