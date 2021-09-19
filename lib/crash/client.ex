defmodule Crash.Client do
  @moduledoc "Simplest client for Crash application"

  def send_commit(client, data) do
    Tesla.post(client, "/webhook/github", data)
  end

  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:3000"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
