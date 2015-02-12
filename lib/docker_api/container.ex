defmodule DockerApi.Container do

  def all(host) when is_binary(host) do
    HTTPoison.get host <> "/containers/json"
  end

  def get(host, id) do
    response = HTTPoison.get host <> "/containers/#{id}/json"
    response |>
    parse_response 
  end
  
  def top(host, id) do
    response = HTTPoison.get host <> "/containers/#{id}/top/json"
    response |>
    parse_response 
  end
  
  def changes(host, id) do
    response = HTTPoison.get host <> "/containers/#{id}/changes/json"
    response |>
    parse_response 
  end
  
  def start(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/start"
    response |>
    parse_response
  end

  def stop(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/stop"
    response |>
    parse_response
  end

  def restart(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/restart"
    response |>
    parse_response
  end

  def kill(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/kill"
    response |>
    parse_response
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
  
  def attach(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/attach?logs=1&stream=0&stdout=1"
    response
  end

  def parse_response(response) do
    { Poison.decode(response.body), response.status_code }
  end
  
end

