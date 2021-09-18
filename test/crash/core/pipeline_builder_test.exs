defmodule Crash.Core.PipelineBuilderTest do
  @moduledoc false

  use ExUnit.Case

  import ExUnit.CaptureLog

  alias Crash.Core.Pipeline
  alias Crash.Core.PipelineBuilder
  alias Crash.Core.Step

  test "build steps" do
    steps = [[name: "0", commands: ["cat /dev/null"], image: "test/test"]]
    {:ok, %Pipeline{steps: made_steps}} = PipelineBuilder.build(%{steps: steps})

    assert made_steps == [%Step{commands: ["cat /dev/null"], image: "test/test", name: "0"}]
  end

  test "build steps, error" do
    captured_logs =
      capture_log(fn ->
        {result, _} = PipelineBuilder.build(123)

        assert result == :error
      end)

    assert captured_logs =~ ~r/.*\[error\] received unexpected raw pipeline/
  end
end
