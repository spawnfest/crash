defmodule Crash.FakeServers.Github do
  @moduledoc false

  use Plug.Router

  plug :match
  plug :dispatch

  get "/repos/:owner/:repo/contents/.dronex.yml" do
    conn
    |> put_resp_content_type("application/vnd.github.v3.raw")
    |> send_resp(
      200,
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

        - name: another-test
          image: node:15.4.0-alpine
          commands:
            - npm install
            - npm test
      """
    )
  end
end
