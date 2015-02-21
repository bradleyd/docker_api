DockerApi
=========

A Docker Api client for Elixir

[Docker API Version](https://docs.docker.com/v1.4/reference/api/docker_remote_api_v1.16/)


* currently only supports TCP

#### Usage

Add `docker_api` to your `mix.exs`

```elixir
  defp deps do
    [
      {:docker_api, git: "https://github.com/bradleyd/docker_api.git"}
    ]   
  end
```

Make sure it gets started

```elixir
  def application do
    [applications: [:logger, :docker_api]]
```

You can start it by hand also

```elixir
DockerApi.start #=> {:ok, []}
```

#### Container

`all\1`

```elixir
{:ok, body, code } = DockerApi.all("127.0.0.1")
```

`get\2`

```elixir
{:ok, body, code } = DockerApi.Container.get("127.0.0.1", "12345")
```

`top\2`

 ```elixir
{:ok, body, code } = DockerApi.Container.top("127.0.0.1", "12345")
```

`create\2`

 ```elixir
{:ok, body, code } = DockerApi.Container.create("127.0.0.1", %{image: "foo"})
```


#### Images

`all\1`

```elixir
{:ok, body, code } = DockerApi.Image.all("127.0.0.1")
```

`find\1`

```elixir
{ :ok, body, code } = DockerApi.Image.find("127.0.0.1", "12345")
```

`build\3`

```elixir
{:ok, result } = DockerApi.Image.build(@host, %{t: "foo", q: 1}, "/tmp/docker_image.tar.gz")
```


### TODO

- [ ] Finish mapping all the API endpoints
- [ ] Finish docstrings 
- [ ] Mock all the HTTP calls
