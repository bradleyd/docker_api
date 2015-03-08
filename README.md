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
  end
```

You can start it by hand also

```elixir
DockerApi.start #=> {:ok, []}
```

#### Container

__all\1__

```elixir
{:ok, body, code } = DockerApi.all("127.0.0.1")
```

__find\2__

```elixir
{:ok, body, code } = DockerApi.Container.get("127.0.0.1", "12345")
```
__find\2__

Find can also take a List of hosts to search through.

```elixir
{:ok, body, code } = DockerApi.Container.get(["127.0.0.1", "10.100.13.21"], "12345")
```

__top\2__

 ```elixir
{:ok, body, code } = DockerApi.Container.top("127.0.0.1", "12345")
```

__create\2__

 ```elixir
{:ok, body, code } = DockerApi.Container.create("127.0.0.1", %{image: "foo"})
```

__logs__\2

 ```elixir
{:ok, body, code } = DockerApi.Container.logs("127.0.0.1", "12345")
```

To run a command on a container, you must create a Exec first.
exec returns a `Id` to query with

__exec__\3

```elixir
payload = %{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty": false, "Cmd": ["date"] }
{:ok, body, code }  = DockerApi.Container.exec("127.0.0.1", "12345", payload)
#=> %{ "Id" => "1234556678890" }
```

With our `Id` in hand we can then get the results of the Exec

__exec_start__\3

```elixir
payload = %{"Detach": false, "Tty": true}
{:ok, body }  = DockerApi.Container.exec_start("127.0.0.1", "1234556678890", payload)

#=> ["Sun Mar  8 00:25:18 UTC 2015\n"]
```

#### Images

__all\1__

```elixir
{:ok, body, code } = DockerApi.Image.all("127.0.0.1")
```

__find\2__

```elixir
{ :ok, body, code } = DockerApi.Image.find("127.0.0.1", "12345")
```

Find also takes a List of hosts. Find will search all hosts in the list for a match with that `id`

```elixir
{ :ok, body, code } = DockerApi.Image.find(["127.0.0.1", "10.10.100.12"], "12345")
```


__build\3__

```elixir
{:ok, result } = DockerApi.Image.build("127.0.0.1", %{t: "foo", q: 1}, "/tmp/docker_image.tar.gz")
```


### TODO

- [ ] Finish mapping all the API endpoints
- [ ] Events do not stream forever; only show because of IO.inspect
- [ ] Talk to docker hosts that use credentails/TLS
- [ ] Finish docstrings 
- [ ] Mock all the HTTP calls
