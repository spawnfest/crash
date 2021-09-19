defmodule CrashWeb.Builders.UserBuilder do
  @moduledoc false

  alias Crash.Core.User

  def build(overrides \\ %{}) do
    struct!(
      User,
      DeepMerge.deep_merge(
        %{
          username: "Codertocat",
          email: "21031067+Codertocat@users.noreply.github.com"
        },
        overrides
      )
    )
  end
end
