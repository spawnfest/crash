defmodule Crash.Core.Step do
  @moduledoc false

  @type t :: %__MODULE__{
          name: String.t(),
          commands: [String.t()],
          image: String.t(),
          logs: [String.t()]
        }

  @derive Jason.Encoder
  defstruct [
    :name,
    :commands,
    :image,
    :logs
  ]

  use ExConstructor
end
