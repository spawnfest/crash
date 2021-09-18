defmodule Crash.Docker.Volumes do
  @moduledoc false

  @type result :: Tesla.Env.result()

  alias Crash.Docker.Client

  @base_uri "/volumes"

  @spec list :: result
  def list do
    Client.get(@base_uri)
  end

  @spec create :: result
  def create do
    Client.post("#{@base_uri}/create", %{labels: %{Crash: "1"}})
  end
end
