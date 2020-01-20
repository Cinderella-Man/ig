defmodule Ig.MixProject do
  use Mix.Project

  def project do
    [
      app: :ig,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Ig, []},
      applications: [:exconstructor, :poison, :httpoison],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 4.0.0"},
      {:exconstructor, "~> 1.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:exvcr, "~> 0.10.1", only: :test}
    ]
  end

  defp description do
    """
    Elixir wrapper for the IG's API
    """
  end

  defp package do
    [
      name: :ig,
      files: ["lib", "config", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Kamil Skowron"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/frathon/ig"}
    ]
  end
end
