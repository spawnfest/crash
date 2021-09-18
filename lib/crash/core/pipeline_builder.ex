defmodule Crash.Core.PipelineBuilder do
  @moduledoc false

  require Logger

  alias Crash.Core.Pipeline
  alias Crash.Core.Step

  @spec build(map) :: {:ok, Pipeline.t()} | {:error, any}
  def build(%{steps: steps}) do
    {:ok,
     steps
     |> Enum.map(&Step.new/1)
     |> (fn x -> %{steps: x} end).()
     |> Pipeline.new()}
  end

  def build(raw_pipeline) do
    Logger.error(fn -> "received unexpected raw pipeline: " <> inspect(raw_pipeline) end)

    {:error, :invalid_pipeline}
  end
end
