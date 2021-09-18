defmodule Crash.Docker.Misc do
  @moduledoc false

  @type result :: Tesla.Env.result()

  alias Crash.Docker.Client

  @spec info :: result
  def info do
    Client.get("/info")
  end

  @spec version :: result
  def version do
    Client.get("/version")
  end

  @spec ping :: result
  def ping do
    Client.get("/_ping")
  end
end
