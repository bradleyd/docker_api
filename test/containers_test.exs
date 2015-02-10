defmodule DockerApiContainerTest do
  use ExUnit.Case

  test "/containers returns containers in json" do
    results = DockerApi.Container.all
    assert is_list(results) 
  end

  test "/containers/id/json returns a container " do
    results = DockerApi.Container.get("765558")
    IO.inspect results 
  end
  
  
end
