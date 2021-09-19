defmodule Crash.Core.Step do
  @moduledoc false

  @type t :: %__MODULE__{
          name: String.t(),
          commands: [String.t()],
          image: String.t(),
          logs: [String.t()],
          result: :success | :warning | :error
        }

  @derive Jason.Encoder
  defstruct [
    :name,
    :commands,
    :image,
    :logs,
    :result
  ]

  use ExConstructor
end
