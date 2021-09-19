defmodule Crash.Docker.Client do
  @moduledoc false

  @type url :: binary
  @type body :: any
  @type result :: Tesla.Env.result()

  require Logger

  alias Crash.Support.Environment

  defp base_url do
    protocol = Environment.get(:docker, :protocol)
    host = Environment.get(:docker, :host) |> String.replace("/", "%2F")
    version = Environment.get(:docker, :version)

    String.trim_trailing("#{protocol}://#{host}/#{version}", "/")
  end

  defp new(base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Headers, [{"content-type", "application/json"}]}
    ]

    Tesla.client(middleware)
  end

  @spec get(url) :: result
  def get(resource) do
    base_url() |> new() |> Tesla.get(resource)
  end

  @spec post(url) :: result
  @spec post(url, body) :: result
  def post(resource, body \\ nil) do
    base_url() |> new() |> Tesla.post(resource, body)
  end
end
