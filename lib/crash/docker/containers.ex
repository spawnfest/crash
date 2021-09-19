defmodule Crash.Docker.Containers do
  @moduledoc """
  Raw implementation of Create and manage containers
  from https://docs.docker.com/engine/api/v1.41/#tag/Container
  """

  @type result :: Tesla.Env.result()

  alias Crash.Docker.Client

  @base_uri "/containers"

  @spec list :: result
  def list do
    Client.get("#{@base_uri}/json?all=true")
  end

  @spec create(any) :: result
  def create(options) do
    Client.post("#{@base_uri}/create", Jason.encode!(options))
  end

  @spec start(String.t()) :: result
  def start(id) do
    Client.post("#{@base_uri}/#{id}/start")
  end

  @spec status(String.t()) :: result
  def status(id) do
    Client.get("#{@base_uri}/#{id}/json")
  end

  @spec logs(String.t()) :: result
  def logs(id) do
    Client.get("#{@base_uri}/#{id}/logs?stdout=true&stderr=true&follow=1")
  end
end
