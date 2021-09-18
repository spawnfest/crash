defmodule Crash.Github.Commit do
  @moduledoc false

  alias Crash.Github.Repository
  alias Crash.Github.User

  @type t :: %__MODULE__{
          sha: String.t(),
          message: String.t(),
          timestamp: DateTime.t(),
          author: User.t(),
          repository: Repository.t()
        }

  @derive Jason.Encoder
  defstruct [
    :sha,
    :message,
    :timestamp,
    :author,
    :repository
  ]

  use ExConstructor
end
