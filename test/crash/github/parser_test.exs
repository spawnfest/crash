defmodule Crash.Github.ParserTest do
  @moduledoc false

  use ExUnit.Case

  import ExUnit.CaptureLog

  alias Crash.Github.Parser

  test "push_event no repository" do
    captured_logs =
      capture_log(fn ->
        res =
          Parser.push_event(%{
            "ref" => "01",
            "compare" => "02",
            "head_commit" => %{
              "id" => 1,
              "message" => "feat: test",
              "author" => %{
                "username" => "sphaso",
                "email" => "sphaso@me.me"
              },
              "timestamp" => "2021-09-18 09:07:57+00"
            }
          })

        assert res == {:error, :invalid_event}
      end)

    assert captured_logs =~ ~r/.*\[warn\] invalid event .+/
  end

  test "push_event complete map" do
    res =
      Parser.push_event(%{
        "ref" => "01",
        "compare" => "02",
        "head_commit" => %{
          "id" => 1,
          "message" => "feat: test",
          "author" => %{
            "username" => "sphaso",
            "email" => "sphaso@me.me"
          },
          "timestamp" => "2021-09-18 09:07:57+00"
        },
        "repository" => %{
          "name" => "crash",
          "full_name" => "spawnfest/crash",
          "git_url" => "https://github.com/spawnfest/crash",
          "owner" => %{
            "name" => "lucazulian",
            "email" => "lucazulian@me.me"
          }
        }
      })

    assert match?({:ok, _}, res)
  end
end
