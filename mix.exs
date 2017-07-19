defmodule Verily.Mixfile do
  use Mix.Project

  def project do
    [app: :verily,
     version: "0.1.0",
     elixir: "~> 1.4.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: compilers(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [ mod: {Verily.Application, []},
      extra_applications: [:logger]]
  end

  def compilers do
    [:phoenix] ++ Mix.compilers
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:phoenix, "~> 1.2"},
      {:phoenix_pubsub, "~> 1.0"}
    ]
  end
end
