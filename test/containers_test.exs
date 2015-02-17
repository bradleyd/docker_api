defmodule DockerApiContainerTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"

  test "/containers" do
    {body, code } = DockerApi.Container.all("192.168.4.4:14443")
    assert is_map(body) 
  end

  test "/containers/id" do
    {:ok, body, code }  = DockerApi.Container.get("192.168.4.4:14443", "971f52624eb3")
    assert is_map(body) 
  end
 
  test "/containers/id/top" do
    { body, code } = DockerApi.Container.top("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
  end

  test "/containers/id/changes" do
    { body, code } = DockerApi.Container.changes("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
  end
  
  test "/containers/id/start" do
    { body, code } = DockerApi.Container.start("192.168.4.4:14443", "971f52624eb325de17737283b5096546ec59db8e541b70d5bfa0cd8846d6560b")
    IO.inspect code
  end

  test "/containers/id/stop" do
    { body, code } = DockerApi.Container.start("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
  end

end
