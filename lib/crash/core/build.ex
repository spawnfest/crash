defmodule Crash.Core.Build do
  @moduledoc false

  alias Crash.Core.Pipeline
  alias Crash.Core.Repository
  alias Crash.Core.Step

  @type t :: %__MODULE__{
          id: binary(),
          repository: Repository.t(),
          pipeline: Pipeline.t(),
          state: :ready | :running | :finished,
          completed_steps: [Step.t()],
          volumes: String.t(),
          started: Time.t()
        }

  @derive Jason.Encoder
  defstruct [
    :id,
    :repository,
    :pipeline,
    :state,
    :completed_steps,
    :volumes,
    :started
  ]

  use ExConstructor
end
