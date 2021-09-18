defmodule Crash.Github.Client do
  @moduledoc false

  @type url :: binary
  @type result :: {:ok, binary} | {:error, :unexpected_response | :error_response}

  require Logger

  alias Crash.Github.Commit
  alias Crash.Support.Environment

  @base_url Environment.get(:github, :base_url)

  defp new do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Compression, "gzip"},
      {Tesla.Middleware.Headers,
       [
         {"user-agent", "Crash"},
         {"accept", "application/vnd.github.v3.raw"}
       ]}
    ]

    Tesla.client(middleware)
  end

  @spec fetch_pipeline(Commit.t()) :: result
  def fetch_pipeline(commit_info) do
    "/repos/#{commit_info.repository.full_name}/contents/.crash.yml"
    |> get()
    |> parse_response()
  end

  defp get(resource) do
    new() |> Tesla.get(resource)
  end

  defp parse_response({:ok, %Tesla.Env{body: body, status: status}}) when status in [200] do
    {:ok, body}
  end

  defp parse_response({:ok, %Tesla.Env{} = response}) do
    Logger.error(fn -> "received unexpected response: " <> inspect(response) end)

    {:error, :unexpected_response}
  end

  defp parse_response({:error, error}) do
    Logger.error(fn -> "received unexpected error: " <> inspect(error) end)

    {:error, :error_response}
  end
end
