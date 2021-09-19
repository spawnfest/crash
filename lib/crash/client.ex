defmodule Crash.Client do
  @moduledoc "Simplest client for Crash application"

  @spec send_commit(client :: Tesla.Env.client(), data :: map()) :: Tesla.Env.result()
  def send_commit(client, data) do
    Tesla.post(client, "/webhook/github", data)
  end

  @spec client(base_url :: String.t()) :: Tesla.Env.client()
  def client(base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
