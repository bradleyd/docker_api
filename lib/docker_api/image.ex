defmodule DockerApi.Image do
  import DockerApi.HTTP, only: :functions
  alias DockerApi.HTTP

  def all(host) when is_binary(host) do
    response = HTTP.get(host <> "/images/json", %{all: 1})
    handle_response(response)
  end

  def find(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/images/#{id}/json")
    handle_response(response)
  end

  def history(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/images/#{id}/history")
    handle_response(response)
  end

end
