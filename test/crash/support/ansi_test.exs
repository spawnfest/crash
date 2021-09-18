defmodule Crash.Support.AnsiTest do
  @moduledoc false

  use ExUnit.Case

  alias Crash.Support.Ansi

  test "strip ansi color text" do
    log =
      "\u001B[0m\u001B[37;40mnpm\u001B[0m \u001B[0m\u001B[34;40mnotice\u001B[0m\u001B[35m\u001B[0m \u001B[40m\u001B[37mRun \u001B[32mnpm install -g npm@7.24.0\u001B[39m\u001B[37m to update!\u001B[39m\u001B[49m"

    stripped = "npm notice Run npm install -g npm@7.24.0 to update!"

    assert stripped == Ansi.strip(log)
  end
end
