defmodule Crash.Github.Parser do
  @moduledoc false

  require Logger

  alias Crash.Github.Commit
  alias Crash.Github.Repository
  alias Crash.Github.User

  @spec push_event(map) :: {:ok, Commit.t()} | {:error, any}
  def push_event(
        %{
          "ref" => ref,
          "compare" => compare,
          "head_commit" => %{
            "id" => id,
            "message" => message,
            "author" => %{
              "username" => author_username,
              "email" => author_email
            },
            "timestamp" => timestamp
          },
          "repository" => %{
            "name" => repository_name,
            "full_name" => repository_full_name,
            "git_url" => git_url,
            "owner" => %{
              "name" => owner_username,
              "email" => owner_email
            }
          }
        } = event
      ) do
    owner = User.new(%{username: owner_username, email: owner_email})

    repository =
      Repository.new(%{
        url: git_url,
        ref: ref,
        name: repository_name,
        full_name: repository_full_name,
        owner: owner,
        compare: compare
      })

    author = User.new(%{username: author_username, email: author_email})

    {:ok, datetime, 0} = DateTime.from_iso8601(timestamp)

    commit =
      Commit.new(%{
        sha: id,
        message: message,
        timestamp: datetime,
        author: author,
        repository: repository
      })

    {:ok, commit}
  rescue
    error ->
      Logger.error(fn -> "Invalid event #{inspect(event)} with error #{inspect(error)}" end)

      {:error, :invalid_event}
  end

  def push_event(event) do
    Logger.error(fn -> "Invalid event #{inspect(event)}" end)

    {:error, :invalid_event}
  end
end
