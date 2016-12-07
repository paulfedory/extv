defmodule ExTV.Mixfile do
  use Mix.Project

  def project do
    [app: :extv,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :poison],
     mod: {ExTV, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
       {:httpoison, "~> 0.10"},
       {:poison, "~> 3.0"},
       {:exvcr, "~> 0.8.4", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Paul Fedory"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/paulfedory/extv" }
    ]
  end
end
