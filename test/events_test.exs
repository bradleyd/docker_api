defmodule DockerApiEventsTest do
  use ExUnit.Case

  import Mock

  @host Application.get_env(:docker_api, :host)

  test "/events" do
    with_mock DockerApi.Events, [all: fn(_host) -> {:ok, []} end] do
      {:ok, body }  = DockerApi.Events.all(@host)
      assert called DockerApi.Events.all(@host)
    end
  end

  test "/events with options" do
    with_mock DockerApi.Events, [all: fn(_host, %{since: 1374067924, until: 1425227650}) -> {:ok, []} end] do
      DockerApi.Events.all(@host, %{since: 1374067924, until: 1425227650})
      assert called DockerApi.Events.all(@host, %{since: 1374067924, until: 1425227650})
    end
  end

end
