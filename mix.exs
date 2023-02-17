defmodule TheZuulWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :list_jobs,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TheZuulWatcher.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.9"},
      {:jason, "~> 1.2"},
      {:websockex, "~> 0.4.3"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end
end
