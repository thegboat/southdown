defmodule Southdown.MixProject do
  use Mix.Project

  def project do
    [
      app: :southdown,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:mox, "~> 1.2.0", only: [:test]},
      {:credo, "~> 1.7.11", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.4.5", only: [:dev], runtime: false},
      {:poolboy, "~> 1.5.2"},
      {:jason, "~> 1.4.4", only: [:test, :dev]},
      {:redix, "~> 1.5.2"}
    ]
  end
end
