defmodule CrashWeb.Builders.PipelineBuilder do
  @moduledoc false

  alias Crash.Core.Pipeline
  alias CrashWeb.Builders.StepBuilder

  def build(overrides \\ %{}) do
    struct!(
      Pipeline,
      DeepMerge.deep_merge(
        %{
          steps: [StepBuilder.build()]
        },
        overrides
      )
    )
  end
end
