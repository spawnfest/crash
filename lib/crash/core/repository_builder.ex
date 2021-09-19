defmodule Crash.Core.RepositoryBuilder do
  @moduledoc false

  require Logger

  alias Crash.Core.Commit, as: CoreCommit
  alias Crash.Core.Repository, as: CoreRepository
  alias Crash.Core.User, as: CoreUser
  alias Crash.Github.Commit, as: GithubCommit
  alias Crash.Github.Repository, as: GithubRepository
  alias Crash.Github.User, as: GithubUser

  @spec build(GithubCommit.t()) :: {:ok, CoreRepository.t()} | {:error, any}
  def build(%GithubCommit{
        sha: git_sha,
        message: git_message,
        timestamp: git_timestamp,
        author: %GithubUser{
          username: git_author_username,
          email: git_author_email
        },
        repository: %GithubRepository{
          url: git_url,
          ref: git_ref,
          name: git_name,
          full_name: git_full_name,
          owner: %GithubUser{
            username: git_owner_username,
            email: git_owner_email
          },
          compare: git_compare
        }
      }) do
    {
      :ok,
      CoreRepository.new(%{
        url: git_url,
        ref: git_ref,
        name: git_name,
        full_name: git_full_name,
        owner:
          CoreUser.new(%{
            username: git_owner_username,
            email: git_owner_email
          }),
        compare: git_compare,
        commit:
          CoreCommit.new(%{
            sha: git_sha,
            message: git_message,
            timestamp: git_timestamp,
            author:
              CoreUser.new(%{
                username: git_author_username,
                email: git_author_email
              })
          })
      })
    }
  end

  def build(commit) do
    Logger.error(fn -> "Received invalid_commit: #{inspect(commit)}" end)

    {:error, :invalid_commit}
  end
end
