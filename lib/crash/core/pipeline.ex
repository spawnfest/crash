defmodule Crash.Core.Pipeline do
  @moduledoc false

  alias Crash.Core.Step

  @type t :: %__MODULE__{
          steps: [Step.t()]
        }

  @derive Jason.Encoder
  defstruct [
    :steps
  ]

  use ExConstructor
end
