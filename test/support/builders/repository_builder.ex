defmodule CrashWeb.Builders.RepositoryBuilder do
  @moduledoc false

  alias Crash.Core.Repository
  alias CrashWeb.Builders.CommitBuilder
  alias CrashWeb.Builders.UserBuilder

  def build(overrides \\ %{}) do
    struct!(
      Repository,
      DeepMerge.deep_merge(
        %{
          url: URI.parse("https://github.com/Codertocat"),
          ref: "refs/heads/master",
          name: "crash-example",
          full_name: "lucazulian/crash-example",
          owner: UserBuilder.build(),
          compare:
            URI.parse(
              "https://github.com/Codertocat/Hello-World/compare/6113728f27ae...000000000000"
            ),
          commit: CommitBuilder.build()
        },
        overrides
      )
    )
  end
end
