defmodule Mix.Tasks.GenerateCommit do
  @moduledoc "The generate commit mix task: `mix help generate_commit`"

  use Mix.Task

  @shortdoc "Simply calls the fake commit generator function."
  def run(_) do
    IO.puts("hello")
  end
end
