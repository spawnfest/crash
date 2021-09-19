defmodule CrashWeb.Builders.CommitBuilder do
  @moduledoc false

  alias Crash.Core.Commit
  alias CrashWeb.Builders.UserBuilder

  def build(overrides \\ %{}) do
    struct!(
      Commit,
      DeepMerge.deep_merge(
        %{
          sha: "6113728f27ae82c7b1a177c8d03f9e96e0adf246",
          message: "Update README.md",
          timestamp: DateTime.utc_now(),
          author: UserBuilder.build()
        },
        overrides
      )
    )
  end
end
