defmodule Twaiter.MixProject do
  use Mix.Project

  def project do
    [
      app: :twaiter,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Twaiter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:hunter, "~> 0.4"},
      {:hunter, github: "milmazz/hunter"},
      {:camarero, "~> 0.11"},
      # dev, test
      {:mox, "~> 1.0", only: [:test]},
      {:credo, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:ex_doc, "~> 0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_),     do: ["lib"]
end
