defmodule CrashWeb.Controllers.Build do
  @moduledoc false

  use Phoenix.Controller, namespace: CrashWeb

  require Logger

  alias Crash.Build.Engine
  alias Crash.Core.PipelineBuilder
  alias Crash.Core.RepositoryBuilder
  alias Crash.Github.Client
  alias Crash.Github.Parser
  alias Crash.Support.Data

  def execute(conn, params) do
    with {:ok, commit} <- Parser.push_event(params),
         {:ok, raw_pipeline} <- Client.fetch_pipeline(commit),
         {:ok, parsed_pipeline} <- YamlElixir.read_from_string(raw_pipeline),
         {:ok, pipeline} <- PipelineBuilder.build(Data.atomize_keys(parsed_pipeline)),
         {:ok, repository} <- RepositoryBuilder.build(commit),
         {:ok, build} <- Engine.schedule(pipeline, repository) do
      send_resp(conn, 200, Jason.encode!(build))
    else
      error ->
        Logger.error(fn -> error end)

        send_resp(conn, 500, "oops")
    end
  end

  def build(conn, %{"id" => build_id}) do
    case Engine.status(build_id) do
      {:ok, build} ->
        send_resp(conn, 200, Jason.encode!(build))

      {:error, error} ->
        Logger.error(fn -> error end)

        send_resp(conn, 500, "oops")
    end
  end
end
