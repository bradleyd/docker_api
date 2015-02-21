defmodule DockerApi.Image do
  import DockerApi.HTTP, only: :functions
  alias DockerApi.HTTP

  @docmodule """
    Docker Image API
  """

  @doc """
  Get all the images from a docker host
    
     iex> DockerApi.all("127.0.0.1")
       []
  """
  def all(host) when is_binary(host) do
    response = HTTP.get(host <> "/images/json", %{all: 1})
    handle_response(response)
  end

  @doc """
  Find a specific image by id or name

    iex> DockerApi.find("127.0.0.1", "foo")
      []

  """
  def find(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/images/#{id}/json")
    handle_response(response)
  end

  def history(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/images/#{id}/history")
    handle_response(response)
  end

  def delete(host, id, opts) do
    response = HTTP.delete(host <> "/images/#{id}", opts)
    handle_response(response)
  end

  @doc """
  Create an image 
  
  host: docker host
  opts: query parameters 

  * please see docker api docs for full list of query parameters

  """
  def create(host, opts) when is_binary(host) and is_map(opts) do
    url = "#{host}/images/create?#{encode_query_params(opts)}"
    {:ok, %HTTPoison.AsyncResponse{id: id}} = HTTPoison.post(url, "", %{"content-type" => "application/json"}, stream_to: self)
    {:ok, agent} = Agent.start_link fn -> [] end
    results = stream_loop(id, agent)
    Agent.stop(agent)
    {:ok, results}
  end

  @doc """
    Build an image from a Dockerfile


    * Dockerfile must be a tar file
    * See docker api for query parameters

      
       iex> DockerApi.Image("192.168.4.4:14443", %{t: "foo"}, "/tmp/docker.tar.gz"
       
       [%{"stream" => "Successfully built 8b4"}, ...]

  """ 
  def build(host, opts, filepath) do
    file = File.read!(filepath)
    url = "#{host}/build?#{encode_query_params(opts)}"
    {:ok, %HTTPoison.AsyncResponse{id: id}} = HTTPoison.post(url, file, %{"content-type" => "application/tar"}, stream_to: self) 
    {:ok, agent} = Agent.start_link fn -> [] end
    results = stream_loop(id, agent)
    Agent.stop(agent)
    {:ok, results}
  end
  
  defp stream_loop(id, agent) do
    receive do
      %HTTPoison.AsyncStatus{ id: id, code: 200 } -> stream_loop(id, agent)
      %HTTPoison.AsyncHeaders{headers: _, id: id} -> stream_loop(id, agent)
      %HTTPoison.AsyncChunk{id: id, chunk: chk} -> 
        if String.valid?(chk) do
          #IO.inspect Poison.decode!(chk)
          Agent.update(agent, fn set -> [Poison.decode!(chk)|set] end)
        end
        stream_loop(id, agent)
      %HTTPoison.AsyncEnd{id: id} -> 
        #IO.puts "End of stream"
        Agent.get(agent, fn set -> set end)
    after
      5_000 -> "Timeout waiting for stream"
    end
  end

end
