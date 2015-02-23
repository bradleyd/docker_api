defmodule DockerApi.Container do

  import DockerApi.HTTP, only: :functions
  alias DockerApi.HTTP

  @doc """
  Fetch all the containers from a given docker host

  host: "127.0.0.1"
    
     iex> DockerApi.Container.find("127.0.0.1")
        [%{...}, ..]
  """
  def all(host) when is_binary(host) do
    response = HTTP.get(host <> "/containers/json", %{all: 1})
    handle_response(response)
  end

  @doc """
  Fetch all the containers from a given docker host

  host: "127.0.0.1"
  opts: %{}

  * See docker API documentation for full list of query parameters

      iex> DockerApi.Container.all("127.0.0.1", %{all: 1})
        [%{...}, ..]
  """
  def all(host, opts) when is_map(opts) do
    response = HTTP.get(host <> "/containers/json", opts) 
    handle_response(response)
  end

  @doc """
  Find a container when hosts is a List

  hosts: ["127.0.0.1", 10.10.100.31"]
  id: "1234567" 

      iex> DockerApi.Container.find(["127.0.0.1", 10.10.100.31"], "123456")
        %{...}
  """
  def find(hosts, id) when is_list(hosts), do: _find(hosts, id, %{})
  
  @doc """
  Find a container when hosts is a String

  hosts: "127.0.0.1"
  id: "1234567" 

      iex> DockerApi.Container.find("127.0.0.1", "123456")
        %{...}
  """
  def find(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/containers/#{id}/json")
    handle_response(response)
  end

  defp _find([], _id, result), do: result

  defp _find([head | tail], id, _result) do
    case find(head, id) do
      {:ok, body, 200} when is_map(body) ->
        _find([], id, {:ok, body, 200})
      {result, body, code} -> 
        _find(tail, id, {result, body, code})
    end
  end

  @doc """
  Top running processes inside the container

  """
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

  @doc """
  Delete a container

  host: "127.0.0.1"
  id: "123456"
  otps: %{}
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

  @doc """

  Fetch the logs from a container

  * Returns the last 50 entries for stdout and stderr.

  """
  def logs(host, id) do
    {:ok, %HTTPoison.AsyncResponse{id: id}} = HTTPoison.get host <> "/containers/#{id}/logs?stderr=1&stdout=1&timestamps=1&tail=50", %{}, stream_to: self
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  defp stream_loop(acc, :done), do: acc
  defp stream_loop(acc) do
    receive do
      %HTTPoison.AsyncStatus{ id: id, code: 200 } -> stream_loop(acc)
      %HTTPoison.AsyncHeaders{headers: _, id: id} -> stream_loop(acc)
      %HTTPoison.AsyncChunk{id: id, chunk: chk} -> 
        case String.printable?(chk) do
          true -> stream_loop([chk|acc])
          _    -> stream_loop(acc) #<<stream_type::8, 0, 0, 0, size1::8, size2::8, size3::8, size4::8, rest::binary >> = chk
        end
      %HTTPoison.AsyncEnd{id: id} ->
        stream_loop(acc, :done)
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
