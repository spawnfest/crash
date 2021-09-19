defmodule CrashWeb.Builders.StepBuilder do
  @moduledoc false

  alias Crash.Core.Step

  def build(overrides \\ %{}) do
    struct!(
      Step,
      DeepMerge.deep_merge(
        %{
          name: "clone",
          commands: ["git clone https://github.com/left-pad/left-pad/ --depth=1 ."],
          image: " alpine/git:v2.26.2",
          logs: [],
          result: nil
        },
        overrides
      )
    )
  end
end
