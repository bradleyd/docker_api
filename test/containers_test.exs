defmodule DockerApiContainerTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"
  @cid "0c3d7cdb6f3a"

  setup_all do
    results = create_container
    on_exit fn ->
      delete_container(Map.get(results, "Id"))
    end
    {:ok, id: Map.get(results, "Id")}
  end

  defp delete_container(id) do
    {:ok, body, code }  = DockerApi.Container.delete(@host, id, %{force: 1})
  end

  defp create_container do
    payload  = %{ "Image": "redis",
      "AttachStdout": true,
      "AttachStderr": true,
      "Hostname": "test_redis",
      "HostConfig": %{ "Dns": ["8.8.8.8"] },
      "ExposedPorts": %{ "22/tcp": %{}, "6379/tcp": %{} },
      "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], 
        "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}

    {:ok, body, code } = DockerApi.Container.create(@host, payload)
    body
  end
  defp create_container(name) do
    payload  = %{ "Image": "redis",
      "AttachStdout": true,
      "AttachStderr": true,
      "Hostname": name,
      "HostConfig": %{ "Dns": ["8.8.8.8"] },
      "ExposedPorts": %{ "22/tcp": %{}, "6379/tcp": %{} },
      "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], 
        "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}

    {:ok, body, code } = DockerApi.Container.create(@host, payload)
    body
  end

  test "/containers" do
    {:ok, body, code }  = DockerApi.Container.all(@host)
    assert is_list(body) 
  end

  test "/containers with options" do
    {:ok, body, code }  = DockerApi.Container.all(@host, %{all: 1, limit: 1, size: 1})
    assert is_list(body) 
  end

  #test "/containers/create" do
  #  payload  = %{ "Image": "redis",
  #                "AttachStdout": true,
  #                "AttachStderr": true,
  #                "Hostname": "test_redis",
  #                "HostConfig": %{ "Dns": ["8.8.8.8"] },
  #                "ExposedPorts": %{ "22/tcp": %{}, "6379/tcp": %{} },
  #                "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], 
  #                                   "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}

  #  {:ok, body, code } = DockerApi.Container.create(@host, payload)
  #  assert code == 201
  #end

  test "/containers/id delete", state do
    results = create_container("test_delete")
    id = Map.get(results, "Id")
    {:ok, body, code }  = DockerApi.Container.delete(@host, id, %{force: 1})
    assert code == 204
  end
 
  test "/containers/id/exec", state do
    payload = %{  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}
    {:ok, body, code } = DockerApi.Container.start(@host, state.id, payload)

    payload = %{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty": false, "Cmd": [ "date"] }
    {:ok, body, code }  = DockerApi.Container.exec(@host, state.id, payload)
    assert code == 201
    { :ok, body, code } = DockerApi.Container.stop(@host, state.id)
  end
 
  test "/containers/id", state do
    {:ok, body, code }  = DockerApi.Container.find(@host, state.id)
    assert is_number(code)
  end
 
  test "/containers/id/top", state do
    payload = %{  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}
    {:ok, body, code } = DockerApi.Container.start(@host, state.id, payload)

    { :ok, body, code } = DockerApi.Container.top(@host, state.id)
    assert is_map(body) 
    { :ok, body, code } = DockerApi.Container.stop(@host, state.id)
  end

  test "/containers/id/changes", state do
    {:ok, body, code} = DockerApi.Container.changes(@host, state.id)
    assert code == 200
  end
  
  test "/containers/id/start with port options", state do
    payload = %{  "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }], "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}}
    {:ok, body, code } = DockerApi.Container.start(@host, state.id, payload)
    assert code == 204
  end

  test "/containers/id/stop", state do
    { :ok, body, code } = DockerApi.Container.stop(@host, state.id)
    assert body == ""
    assert is_number(code)
  end

end
