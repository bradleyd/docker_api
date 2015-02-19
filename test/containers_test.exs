defmodule DockerApiContainerTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"
  @cid "971f52624eb3"

  test "/containers" do
    {:ok, body, code }  = DockerApi.Container.all(@host)
    assert is_list(body) 
  end

  test "/containers with options" do
    {:ok, body, code }  = DockerApi.Container.all(@host, %{all: 1, limit: 1, size: 1})
    assert is_list(body) 
  end

  test "/containers/id" do
    {:ok, body, code }  = DockerApi.Container.get(@host, @cid)
    assert is_map(body) 
  end
 
  test "/containers/id/top" do
    { :ok, body, code } = DockerApi.Container.top(@host, @cid)
    assert is_map(body) 
  end

  test "/containers/id/changes" do
    { :ok, body, code } = DockerApi.Container.changes(@host, @cid)
    assert is_map(body) 
  end
  
  test "/containers/id/start with port options" do
    payload = %{  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}
    {:ok, body, code } = DockerApi.Container.start(@host, @cid, payload)
  end

  test "/containers/id/start with no options" do
    {:ok, body, code } = DockerApi.Container.start(@host, @cid)
  end

  test "/containers/id/stop" do
    { :ok, body, code } = DockerApi.Container.stop(@host, @cid)
  end

end
