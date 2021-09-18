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
         {:ok, raw_pipeline} <- YamlElixir.read_from_string(raw_pipeline),
         {:ok, pipeline} <- PipelineBuilder.build(Data.atomize_keys(raw_pipeline)),
         {:ok, repository} <- RepositoryBuilder.build(commit),
         {:ok, build} <- Engine.schedule(pipeline, repository) do
      send_resp(conn, 200, Jason.encode!(build))
    else
      err ->
        Logger.error(err)
        send_resp(conn, 500, "oops")
    end
  end

  def build(conn, %{"id" => id}) do
    case Engine.status(id) do
      {:ok, build} ->
        send_resp(conn, 200, Jason.encode!(build))

      {:error, error} ->
        Logger.error(error)
        send_resp(conn, 500, "oops")
    end
  end
end
