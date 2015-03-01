defmodule DockerApiEventsTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"

  test "/events" do
    {:ok, body }  = DockerApi.Events.all(@host)
    assert is_list(body) 
  end

  test "/events with options" do
    {:ok, body}  = DockerApi.Events.all(@host, %{since: 1374067924, until: 1425227650})
    assert is_list(body) 
  end
  
end
