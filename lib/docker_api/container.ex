defmodule DockerApi.Container do

  import DockerApi.HTTP, only: :functions
  alias DockerApi.HTTP

  def all(host) when is_binary(host) do
    response = HTTP.get(host <> "/containers/json", %{all: 1})
    handle_response(response)
  end

  def all(host, opts) when is_map(opts) do
    response = HTTP.get(host <> "/containers/json", opts) 
    handle_response(response)
  end

  def get(host, id) do
    response =HTTP.get(host <> "/containers/#{id}/json")
    handle_response(response)
  end
  
  def top(host, id) do
    response = HTTP.get(host <> "/containers/#{id}/top")
    handle_response(response)
  end
  
  def changes(host, id) do
    response = HTTP.get(host <> "/containers/#{id}/changes")
    handle_response(response)
  end
  
  def start(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/start")
    handle_response(response)
  end

  def start(host, id, opts) do
    response = HTTP.post(host <> "/containers/#{id}/start", opts)
    handle_response(response)
  end

  def create(host, opts) do
    response = HTTP.post(host <> "/containers/create", opts)
    handle_response(response)
  end

  def delete(host, id) do
    response = HTTP.delete(host <> "/containers/#{id}")
    handle_response(response)
  end

  """
    v – 1/True/true or 0/False/false, Remove the volumes associated to the container. Default false
    force - 1/True/true or 0/False/false, Kill then remove the container. Default false
  """
  def delete(host, id, opts) do
    response = HTTP.delete(host <> "/containers/#{id}", opts)
    handle_response(response)
  end


  def stop(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/stop")
    handle_response(response)
  end

  def restart(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/restart")
    handle_response(response)
  end

  def kill(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/kill")
    handle_response(response)
  end

  def logs(host, id) do
    {:ok, %HTTPoison.AsyncResponse{id: id}} = HTTPoison.get host <> "/containers/#{id}/logs?stderr=1&stdout=1&timestamps=1", %{}, stream_to: self
    stream_loop(id)
  end


  defp stream_loop(id) do
    receive do
      %HTTPoison.AsyncStatus{ id: id, code: 200 } -> stream_loop(id)
      %HTTPoison.AsyncHeaders{headers: _, id: id} -> stream_loop(id)
      %HTTPoison.AsyncChunk{id: id, chunk: chk} -> 
        if String.valid?(chk) do
          IO.puts(IO.iodata_to_binary(chk))
        end
        stream_loop(id)
      %HTTPoison.AsyncEnd{id: id} -> IO.puts "End of stream"
    after
      5_000 -> "Timeout waiting for stream"
    end
  end
  
  # WIP dont use
  def attach(host, id) do
    response = HTTP.post host <> "/containers/#{id}/attach?logs=1&stream=1&stdout=1&stdin=1"
    response
  end

end
