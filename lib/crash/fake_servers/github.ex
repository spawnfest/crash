defmodule Crash.FakeServers.Github do
  @moduledoc false

  use Plug.Router

  @avaiable_crash_responses [
    """
    steps:
      - name: clone
        image: alpine/git:v2.26.2
        commands:
          - git clone https://github.com/left-pad/left-pad/ --depth=1 .

      - name: test
        image: node:15.4.0-alpine
        commands:
          - npm install
          - npm test

      - name: list
        image: node:15.4.0-alpine
        commands:
          - npm ls
    """,
    """
    steps:
      - name: clone
        image: alpine/git:v2.26.2
        commands:
          - git clone https://github.com/spawnfest/crash --depth=1 .

      - name: dependencies
        image: elixir:1.12.3-alpine
        commands:
          - mix local.hex --force
          - mix deps.get

      - name: compile
        image: elixir:1.12.3-alpine
        commands:
          - apk add git
          - mix local.hex --force
          - mix local.rebar --force
          - mix compile

      - name: test
        image: elixir:1.12.3-alpine
        commands:
          - apk add git
          - mix local.hex --force
          - mix local.rebar --force
          - mix test
    """,
    """
    steps:
      - name: clone
        image: alpine/git:v2.26.2
        commands:
          - git clone https://github.com/spawnfest/crash --depth=1 .

      - name: broken
        image: alpine/git:v2.26.2
        commands:
          - cecinestpasunepipe

      - name: compile
        image: elixir:1.12.3-alpine
        commands:
          - apk add git
          - mix local.hex --force
          - mix local.rebar --force
          - mix compile
    """
  ]

  plug :match
  plug :dispatch

  get "/repos/:owner/:repo/contents/.crash.yml" do
    conn
    |> put_resp_content_type("application/vnd.github.v3.raw")
    |> send_resp(
      200,
      @avaiable_crash_responses |> Enum.random()
    )
  end
end
