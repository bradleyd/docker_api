defmodule DockerApiImageTest do
  use ExUnit.Case
  import PathHelpers

  @host Application.get_env(:docker_api, :host)
  @iid "868be653dea3"

  test "/images" do
    {:ok, body, code } = DockerApi.Image.all(@host)
    assert is_list(body)
    assert is_integer(code)
  end

  test "/images/id" do
    { :ok, body, code } = DockerApi.Image.find(@host, @iid)
    IO.inspect body
    assert is_integer(code)
  end
 
  test "/images/id/history" do
    { :ok, body, code } = DockerApi.Image.history(@host, @iid)
    assert is_integer(code)
  end

  test "/images/foo delete" do
    { :ok, body, code } = DockerApi.Image.delete(@host, "foo", %{force: 1})
    assert is_integer(code)
  end

  test "/build" do
    {:ok, result } = DockerApi.Image.build(@host, %{t: "foo", q: 1}, fixture_path("docker_image.tar.gz"))
    assert is_list(result)
  end

  #test "/images/create" do
    #{ :ok, body, code } = DockerApi.Image.create(@host, %{"fromImage" => "bradleyd/ubuntu-sensu-base", "tag" => "testeroo"})
    #assert is_integer(code)
  #end

end
