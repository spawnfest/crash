defmodule CrashWeb.Controllers.System do
  @moduledoc false

  use Phoenix.Controller, namespace: CrashWeb

  def ping(conn, _params) do
    send_resp(conn, 200, "pong")
  end

  def not_found(conn, _params) do
    send_resp(conn, 404, "")
  end
end
