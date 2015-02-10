defmodule DockerApi.Container do

  def all do
    hosts = Application.get_env(:docker_api, :hosts)
    hosts |> 
    Enum.map(fn(x) -> HTTPotion.get x <> "/containers/json" end)
  end

  def get(id) do
    hosts = Application.get_env(:docker_api, :hosts)
    hosts |> 
    Enum.map(fn(x) -> HTTPotion.get x <> "/containers/#{id}/json" end)
  end
  

end

