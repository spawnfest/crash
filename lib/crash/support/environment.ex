defmodule Crash.Support.Environment do
  @moduledoc false

  @type key :: atom
  @type value :: term

  @app Crash.MixProject.project() |> Keyword.fetch!(:app)

  @spec get(key, key) :: value
  def get(key, subkey) do
    Application.get_env(@app, key)[subkey]
  end
end
