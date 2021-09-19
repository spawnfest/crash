defmodule Mix.Tasks.GenerateCommit do
  @moduledoc "The generate commit mix task: `mix help generate_commit`"

  use Mix.Task

  alias Crash.Client
  alias Crash.Support.Github.FakeCommit

  @shortdoc "Simply calls the fake commit generator function."
  def run(_) do
    Application.ensure_all_started(:hackney)

    IO.puts("Generating dynamic commit...")

    commit = FakeCommit.generate()

    case Client.client() |> Client.send_commit(commit) do
      {:ok, _} ->
        IO.puts("Sent commit to Crash, look at the application for the progess...")

      {:error, reason} ->
        IO.puts("Error while sending commit to Crash: #{inspect(reason)}")
    end
  end
end
