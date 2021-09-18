defmodule Crash.Github.Repository do
  @moduledoc false

  alias Crash.Github.User

  @type t :: %__MODULE__{
          url: URI.t(),
          ref: String.t(),
          name: String.t(),
          full_name: String.t(),
          owner: User.t(),
          compare: URI.t()
        }

  @derive Jason.Encoder
  defstruct [
    :url,
    :ref,
    :name,
    :full_name,
    :owner,
    :compare,
    :commit
  ]

  use ExConstructor
end
