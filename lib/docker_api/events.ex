defmodule DockerApi.Events do
  import DockerApi.HTTP, only: :functions

  @doc """
  Stream docker host events in real time

  * This will block until the timeout is reached.

     iex> DockerApi.Events.all("127.0.0.1")
       [%{...}, ..]
  """
  def all(host) when is_binary(host) do
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTPoison.get host <> "/events", %{}, stream_to: self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  @doc """
  Poll docker host events between since and until

  * if `until` is not supplied the stream will block until the timeout is reached

     iex> DockerApi.Events.all("127.0.0.1", %{since: 1374067924, until: 1425227650})
       [%{...}, ..]
  """
  def all(host, opts) when is_binary(host) and is_map(opts) do
    url = "#{host}/events?#{encode_query_params(opts)}"
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTPoison.get url, %{}, stream_to: self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  defp stream_loop(acc, :done), do: acc
  defp stream_loop(acc) do
    receive do
      %HTTPoison.AsyncStatus{ id: _id, code: 200 } -> stream_loop(acc)
      %HTTPoison.AsyncHeaders{headers: _, id: _id} -> stream_loop(acc)
      %HTTPoison.AsyncChunk{id: _id, chunk: chk} ->
      case String.printable?(chk) do
        true ->
            stream_loop([Poison.decode!(chk)|acc])
        _    ->
            stream_loop(acc) #<<stream_type::8, 0, 0, 0, size1::8, size2::8, size3::8, size4::8, rest::binary >> = chk
      end
      %HTTPoison.AsyncEnd{id: _id} ->
        stream_loop(acc, :done)
    after
      10_000 ->
      IO.puts "Timeout waiting for stream"
      acc
    end
  end
end
