use Mix.Config
config :docker_api, :uri, System.get_env("DOCKER_API_URL") || "http+unix://%2fvar%2frun%2fdocker.sock"
