defmodule DockerApi do
  use Application

  def start do
    Application.ensure_all_started(:httpoison)
  end
end
