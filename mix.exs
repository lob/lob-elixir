defmodule Lob.Mixfile do
  use Mix.Project

  @source_url "https://github.com/lob/lob-elixir"
  @version "1.1.2"

  def project do
    [
      app: :lob_elixir,
      version: @version,
      elixir: "~> 1.4",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      package: package(),
      deps: deps(),
      docs: docs(),
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
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.7.4", only: :test},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1", only: :test}
    ]
  end

  defp package do
    [
      description: "Lob Elixir Library",
      maintainers: ["Lob"],
      files: ["lib/**/*.ex", "mix*", "*.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/lob_elixir/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", {:"README.md", [title: "Overview"]}, "CONTRIBUTING.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
