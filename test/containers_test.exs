defmodule DockerApiContainerTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"

  test "/containers" do
    results = DockerApi.Container.all("192.168.4.4:14443")
    assert is_map(results) 
  end

  test "/containers/id" do
    { body, code } = DockerApi.Container.get("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
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
    { body, code } = DockerApi.Container.start("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
  end

  test "/containers/id/stop" do
    { body, code } = DockerApi.Container.start("192.168.4.4:14443", "d869ff642538359d")
    IO.inspect code
  end

end
