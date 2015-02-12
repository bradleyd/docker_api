defmodule DockerApiImageTest do
  use ExUnit.Case

  @host "192.168.4.4:14443"

  test "/images" do
    {body, code } = DockerApi.Image.all("192.168.4.4:14443")
    assert is_list(body)
    assert is_integer(code)
  end

  test "/images/id" do
    { body, code } = DockerApi.Image.get("192.168.4.4:14443", "566b995648b1becb927a")
    assert is_integer(code)
  end
 
  test "/images/id/history" do
    { body, code } = DockerApi.Image.history("192.168.4.4:14443", "566b995648b1becb927a")
    assert is_integer(code)
  end

  test "/images/search" do
    { body, code } = DockerApi.Image.search("192.168.4.4:14443", "ubuntu")
    assert is_integer(code)
    assert is_list(body)
  end

  #test "/images/id/changes" do
    #{ body, code } = DockerApi.Image.changes("192.168.4.4:14443", "d869ff642538359d")
    #IO.inspect code
  #end
  
  #test "/images/id/start" do
    #{ body, code } = DockerApi.Image.start("192.168.4.4:14443", "d869ff642538359d")
    #IO.inspect code
  #end

  #test "/images/id/stop" do
    #{ body, code } = DockerApi.Image.start("192.168.4.4:14443", "d869ff642538359d")
    #IO.inspect code
  #end

end
