defmodule Devit.MixProject do
  use Mix.Project

  def project do
    [
      app: :devit,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Devit.Application, []}
    ]
  end

  defp escript do
    [
      path: "./bin/devit",
      main_module: Devit.CLI
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.16.0"},
      {:front_matter, "~> 1.0.1"},
      {:jason, ">= 1.0.0"},
      {:cli_spinners, "~> 0.1.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.5.0", only: [:test, :dev], runtime: false}
    ]
  end
end
