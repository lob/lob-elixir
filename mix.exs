defmodule Lob.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lob_elixir,
      version: "1.3.0",
      elixir: "~> 1.12.1",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: "Lob Elixir Library",
      package: package(),
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

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bypass, "~> 0.8", only: :test},
      {:confex, "~> 3.4.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.7.4", only: :test},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Lob"],
      files: ["lib/**/*.ex", "mix*", "*.md"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lob/lob-elixir"}
    ]
  end
end
