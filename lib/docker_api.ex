defmodule DockerApi do
  use Application

  def start(_type, _args) do
    Application.ensure_all_started(:httpoison)
    DockerApi.Supervisor.start_link
  end
end
