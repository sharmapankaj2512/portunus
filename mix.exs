defmodule Portunus.MixProject do
  use Mix.Project

  def project do
    [
      app: :portunus,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Portunus.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ranch, "~> 1.7"},
      {:credo, "~> 1.1.4", only: [:dev, :test], runtime: false},
      {:coverex, "~> 1.4.15", only: :test},
      {:dogma, "~> 0.1.16", only: :dev},
    ]
  end
end
