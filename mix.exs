defmodule DockerApi.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_api,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

   defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
      {:httpoison, "~> 0.6"},
      {:poison, "~> 1.3"}
    ]
  end
end
