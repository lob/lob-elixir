defmodule Lob.Mixfile do
  use Mix.Project

  @source_url "https://github.com/lob/lob-elixir"
  @version "1.5.0"

  def project do
    [
      app: :lob_elixir,
      version: @version,
      elixir: "~> 1.12",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: "Lob Elixir Library",
      package: package(),
      docs: docs(),
      deps: deps(),
      dialyzer: [
        flags: [
          :error_handling,
          :no_opaque,
          :race_conditions,
          :unknown
        ],
        ignore_warnings: ".dialyzer_ignore"
      ],
      xref: [
        exclude: [
          :crypto
        ]
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
      {:bypass, "~> 2.1", only: :test},
      {:confex, "~> 3.5.0"},
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.14", only: :test},
      {:httpoison, "~> 1.8"},
      {:json, "~> 1.4"},
      {:poison, "~> 5.0"},
      {:pre_commit, "~> 0.3.4", only: :dev},
      {:plug_cowboy, "~> 2.5"},
      {:uuid, "~> 1.1", only: :test}
    ]
  end

  defp docs do
    [
      extras: [{:"README.md", title: "Overview"}],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Lob Elixir Library",
      maintainers: ["Lob"],
      files: ["lib/**/*.ex", "mix*", "*.md", "LICENSE.txt"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/lob_elixir/changelog.html",
        "GitHub" => @source_url,
        "API Documentation" => "https://docs.lob.com/"
      }
    ]
  end
end
