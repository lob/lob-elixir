defmodule Lob.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lob_elixir,
      version: "0.1.0",
      elixir: "~> 1.5",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      dialyzer: [
        flags: [
          :error_handling,
          :no_opaque,
          :race_conditions,
          :unknown
        ],
        ignore_warnings: ".dialyzer_ignore"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5.1", only: [:dev, :test], runtime: false},
      {:dogma, "~> 0.1.15", only: [:dev, :test]},
      {:excoveralls, "~> 0.7.4", only: :test}
    ]
  end
end
