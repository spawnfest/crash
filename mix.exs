defmodule Crash.MixProject do
  use Mix.Project

  def project do
    [
      app: :crash,
      version: get_version_number(),
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      mod: {Crash.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.5.12"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ] ++ deps_dev()
  end

  defp deps_dev do
    [
      {:benchfella, "~> 0.3.0", only: [:dev, :test], runtime: false},
      {:credo, "1.5.6", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:exprof, "~> 0.2.0", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:observer_cli, "~> 1.6", only: [:test, :dev]},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:propcheck, "~> 1.1", only: [:test, :dev]},
      {:muzak, "~> 1.1", only: :test}
    ]
  end

  defp aliases do
    [
      c: "compile",
      cc: "compile --all-warnings --ignore-module-conflict --debug-info",
      check: [
        "credo --strict",
        "dialyzer --format dialyzer"
      ],
      cover: "coveralls",
      "cover.detail": "coveralls.detail",
      s: "phx.server",
      setup: ["deps.get", "cmd npm install --prefix assets"],
      "format.all": "format mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}' 'config/*.{ex,exs}'",
      test: "test --trace"
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:ex_unit, :jason, :mix],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/crash_1_12_3_otp_24.plt"}
    ]
  end

  defp preferred_cli_env do
    [
      coveralls: :test,
      cover: :test,
      "cover.detail": :test,
      "cover.html": :test,
      muzak: :test
    ]
  end

  def get_version_number do
    commit = :os.cmd('git rev-parse --short HEAD') |> to_string |> String.trim_trailing("\n")
    v = "0.1.0+#{commit}"

    case Mix.env() do
      :dev -> v <> "dev"
      _ -> v
    end
  end
end
