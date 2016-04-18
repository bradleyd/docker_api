use Mix.Config
config :docker_api, :host, System.get_env("DOCKER_API_HOST") || "127.0.0.1"
config :docker_api, :port, System.get_env("DOCKER_API_PORT") || "2376"