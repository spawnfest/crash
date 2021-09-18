defmodule Crash.Github.User do
  @moduledoc false

  @type t :: %__MODULE__{
          username: String.t(),
          email: String.t()
        }

  @derive Jason.Encoder
  defstruct [
    :username,
    :email
  ]

  use ExConstructor
end
