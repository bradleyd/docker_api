defmodule DockerApi.Container do

  def all(host) when is_binary(host) do
    response = HTTPoison.get host <> "/containers/json" 
    handle_response(response)
  end

  def get(host, id) do
    case HTTPoison.get host <> "/containers/#{id}/json" do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{body: body, status_code: 200}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{body: "Not found", status_code: 404} 
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{body: reason, status_code: 500}
    end 
    |> 
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
  
  def start(host, id, opts \\ %{}) do
    {:ok, response} = HTTPoison.post host <> "/containers/#{id}/start", opts
    response |>
    parse_response
  end

  def stop(host, id) do
    {:ok, response } = HTTPoison.post host <> "/containers/#{id}/stop"
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
  
  # WIP dont use
  def attach(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/attach?logs=1&stream=1&stdout=1&stdin=1"
    response
  end

  def handle_response(resp = {:ok, %{status_code: 200, body: body}}) do
    parse_response(resp)
  end
  
  def handle_response(resp = {:ok, %{status_code: 404 , body: body}}) do 
    parse_response(resp)
  end

  def handle_response(resp = {:error, %HTTPoison.Error{id: _, reason: reason}}) do
    parse_response(resp)
  end

  def parse_response({:error, resp = %HTTPoison.Error{id: _, reason: reason}}) do
    { :error, reason, 500 }
  end

  def parse_response(response) do
    {result, response } = response 
    { result, Poison.decode!(response.body), response.status_code }
  end

  
end
