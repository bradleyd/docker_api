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

  #def search(host, search_term) when is_binary(host) and is_binary(search_term) do
    #parse_get_response(host <> "/images/search?term=#{search_term}")
  #end

  #defp parse_get_response(url) do
    #case HTTPoison.get(url) do
      #{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        #{ decode_json(body), 200 }
      #{:ok, %HTTPoison.Response{status_code: 404}} ->
        #IO.puts "Not found :("
        #{ [], 404 }
      #{:error, %HTTPoison.Error{reason: reason}} ->
        #IO.inspect reason
        #{ reason, 500 }
    #end

  #end

  #defp parse_response(:post, url) do
    #case HTTPoison.post(url) do
      #{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        #{ decode_json(body), 200 }
      #{:ok, %HTTPoison.Response{status_code: 404}} ->
        #IO.puts "Not found :("
        #{ [], 404 }
      #{:error, %HTTPoison.Error{reason: reason}} ->
        #IO.inspect reason
        #{ reason, 500 }
    #end

  #end

  #defp decode_json(body) do
    #{:ok, body} = Poison.decode(body)
    #body
  #end
end
