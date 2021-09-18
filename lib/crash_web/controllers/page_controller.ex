defmodule CrashWeb.PageController do
  use CrashWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
