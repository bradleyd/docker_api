defmodule DockerApiContainerTest do
  use ExUnit.Case

  @host "#{Application.get_env(:docker_api, :host)}:#{Application.get_env(:docker_api, :port)}"
  @cid "86fda78c440e"

  test "/containers" do
    {:ok, body, code }  = DockerApi.Container.all(@host)
    assert is_list(body) 
  end

  test "/containers with options" do
    {:ok, body, code }  = DockerApi.Container.all(@host, %{all: 1, limit: 1, size: 1})
    assert is_list(body) 
  end

  test "/containers/create" do
    payload  = %{ "Image": "redis",
                  "AttachStdout": true,
                  "AttachStderr": true,
                  "Hostname": "test_redis",
                  "HostConfig": %{ "Dns": ["8.8.8.8"] },
                  "ExposedPorts": %{ "22/tcp": %{}, "6379/tcp": %{} },
                  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], 
                                     "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}

    {:ok, body, code } = DockerApi.Container.create(@host, payload)
    assert code == 201
  end

  test "/containers/id delete" do
    {:ok, body, code }  = DockerApi.Container.delete(@host, @cid, %{force: 1})
    assert code == 204
  end
 
  test "/containers/id/exec" do
    payload = %{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty": false, "Cmd": [ "date"] }
    {:ok, body, code }  = DockerApi.Container.exec(@host, @cid, payload)
    assert code == 201
  end
 
  test "/exec/id/start" do
    payload = %{"Detach": false, "Tty": true}
    {:ok, body }  = DockerApi.Container.exec_start(@host, "02ffad5e4dd87fdb15cc70720b496748c1fa80fb9d2840e8a173338e0e18f434", payload)
    IO.inspect body
  end

  test "/containers/id" do
    {:ok, body, code }  = DockerApi.Container.find(@host, @cid)
    IO.inspect body
    assert is_number(code)
  end
 
  test "/containers/id/top" do
    { :ok, body, code } = DockerApi.Container.top(@host, @cid)
    IO.inspect body
    assert is_map(body) 
  end

  test "/containers/id/changes" do
    { :ok, body, code } = DockerApi.Container.changes(@host, @cid)
    assert is_map(body) 
  end
  
  test "/containers/id/start with port options" do
    payload = %{  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}
    {:ok, body, code } = DockerApi.Container.start(@host, @cid, payload)
    IO.inspect body
    IO.inspect code
  end

  test "/containers/id/start with no options" do
    {:ok, body, code } = DockerApi.Container.start(@host, @cid)
  end

  test "/containers/id/stop" do
    { :ok, body, code } = DockerApi.Container.stop(@host, @cid)
    assert code == 204
  end

end
