defmodule DockerApiImageTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"
  @iid "5506de2b643b"

  test "/images" do
    {:ok, body, code } = DockerApi.Image.all(@host)
    assert is_list(body)
    assert is_integer(code)
  end

  test "/images/id" do
    { :ok, body, code } = DockerApi.Image.find(@host, @iid)
    assert is_integer(code)
  end
 
  test "/images/id/history" do
    { :ok, body, code } = DockerApi.Image.history(@host, @iid)
    assert is_integer(code)
  end
end
