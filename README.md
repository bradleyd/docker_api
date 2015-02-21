DockerApi
=========

A Docker Api client for Elixir

[Docker API Version](https://docs.docker.com/v1.4/reference/api/docker_remote_api_v1.16/)


* currently only supports TCP

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
