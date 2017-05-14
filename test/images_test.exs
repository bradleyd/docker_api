defmodule DockerApiImageTest do
  use ExUnit.Case
  import PathHelpers

  @host "#{Application.get_env(:docker_api, :uri)}"

  defp parse_create_image_response(response) do
    %{"stream" => st} = List.first(response)
    case st do
      "sha256:" <> iid -> iid
      "Successfully built " <> iid -> iid
    end
    |> String.trim
  end

  defp create_image do
    {:ok, response} = DockerApi.Image.build(@host, %{t: "foo", q: 1}, fixture_path("docker_image.tar.gz"))
    {:ok, [iid: parse_create_image_response(response)]}
  end

  setup do
    create_image()
  end

  test "/images" do
    {:ok, body, code } = DockerApi.Image.all(@host)
    assert is_list(body)
    assert code == 200
  end

  test "/images/id", context do
    { :ok, _body, code } = DockerApi.Image.find(@host, context[:iid])
    assert code == 200
  end

  test "/images/id/history", context do
    { :ok, _body, code } = DockerApi.Image.history(@host, context[:iid])
    assert code == 200
  end

  test "/images/foo delete", context do
    { :ok, _body, code } = DockerApi.Image.delete(@host, context[:iid], %{force: 1})
    assert code == 200
  end

  test "/images/create" do
    { :ok, body } = DockerApi.Image.create(@host, %{"fromImage" => "redis", "tag" => "alpine"})
    assert is_list(body)
  end

end
