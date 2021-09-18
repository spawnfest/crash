defmodule Crash.Docker.Images do
  @moduledoc false

  @type result :: Tesla.Env.result()

  alias Crash.Docker.Client

  @base_uri "/images"

  @spec list :: result
  def list do
    Client.get("#{@base_uri}/json?all=true")
  end

  @spec pull(String.t()) :: result
  @spec pull(String.t(), String.t()) :: result

  def pull(image) do
    [name, tag] = String.split(image, ":")

    pull(name, tag)
  end

  def pull(name, tag) do
    Client.post("#{@base_uri}/create?tag=#{tag}&fromImage=#{name}")
  end
end
