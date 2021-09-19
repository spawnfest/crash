defmodule CrashWeb.PageLiveTest do
  use CrashWeb.ConnCase

  import Mock
  import Phoenix.LiveViewTest

  alias Crash.Build.Engine

  test "disconnected and connected render", %{conn: conn} do
    with_mock Engine, builds: fn -> [] end do
      {:ok, page_live, disconnected_html} = live(conn, "/")

      assert disconnected_html =~ "Projects"
      assert render(page_live) =~ "Projects"
    end
  end
end
