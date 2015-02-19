defmodule DockerApi.Container do

  def all(host) when is_binary(host) do
    response = HTTPoison.get host <> "/containers/json?all=1" 
    handle_response(response)
  end

  def all(host, opts) when is_map(opts) do
    response = HTTPoison.get host <> "/containers/json?#{query_params(opts)}" 
    handle_response(response)
  end

  def get(host, id) do
    response =HTTPoison.get host <> "/containers/#{id}/json"
    handle_response(response)
  end
  
 
  def top(host, id) do
    response = HTTPoison.get host <> "/containers/#{id}/top"
    handle_response(response)
  end
  
  def changes(host, id) do
    response = HTTPoison.get host <> "/containers/#{id}/changes"
    handle_response(response)
  end
  
  def start(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/start", ""
    handle_response(response)
  end

  def start(host, id, opts) do
    response = HTTPoison.post host <> "/containers/#{id}/start", Poison.encode!(opts),  %{"Content-type" => "application/json"}
    handle_response(response)
  end

  def stop(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/stop", ""
    handle_response(response)
  end

  def restart(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/restart"
    handle_response(response)
  end

  def kill(host, id) do
    response = HTTPoison.post host <> "/containers/#{id}/kill"
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
    response = HTTPoison.post host <> "/containers/#{id}/attach?logs=1&stream=1&stdout=1&stdin=1"
    response
  end

  def handle_response(resp = {:ok, %{status_code: 200, body: body}}) do
    parse_response(resp)
  end
 
  def handle_response(resp = {:ok, %{status_code: 204, body: body}}) do
    parse_response(resp)
  end
 
  def handle_response(resp = {:ok, %{status_code: 304, body: body}}) do
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
  
  def parse_response({:ok, resp=%HTTPoison.Response{body: "", headers: headers, status_code: code}}) do
    {:ok, resp.body, code }
  end

  def parse_response({:ok, resp=%HTTPoison.Response{body: body, headers: %{"Content-Length" =>  _, "Content-Type" => "text/plain; charset=utf-8", "Date" => _}, status_code: code}}) do
    {:ok, body, code }
  end

  def parse_response(response) do
    {result, response } = response 
    {result, Poison.decode!(response.body), response.status_code }
  end

  def query_params(args)  do
   Enum.map(Map.to_list(args), fn {k,v} -> encode_attribute(k, v) end)
   |> Enum.join("&") 
  end
  
  def encode_attribute(k, v), do: "#{k}=#{encode_value(v)}"

  def encode_value(v), do: URI.encode_www_form("#{v}")
end
