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
    {:ok, response } = HTTPoison.get host <> "/containers/#{id}/logs?stderr=1&stdout=1&timestamps=1&follow=1&tail=10", %{}, stream_to: self
    loop(response)
  end


  defp loop(id) do
    receive do
      %HTTPoison.AsyncResponse{id: id} -> "foo"
      %HTTPoison.AsyncStatus{code: 200, id: id} -> loop(id) #IO.puts "good status"
      %HTTPoison.AsyncHeaders{headers: _, id: id} -> loop(id) #"Headers"
      %HTTPoison.AsyncChunk{chunk: chk, id: id} -> 
        IO.inspect to_string(chk)
        loop(%HTTPoison.AsyncChunk{chunk: chk, id: id})
      %HTTPoison.AsyncEnd{id: id} -> "Finsished"
      _ -> "got here"
    after
      5_000 -> "nothing after 1s"
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

