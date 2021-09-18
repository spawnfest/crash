defmodule Crash.Core.Commit do
  @moduledoc false

  alias Crash.Core.User

  @type t :: %__MODULE__{
          sha: String.t(),
          message: String.t(),
          timestamp: DateTime.t(),
          author: User.t()
        }

  @derive Jason.Encoder
  defstruct [
    :sha,
    :message,
    :timestamp,
    :author
  ]

  use ExConstructor
end
