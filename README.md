# The Zuul Watcher

The Zuul Watcher connects to a Zuul instance and record the
job output of all the jobs (websocket).

## Requirements

```
sudo dnf install -y erlang erlang-xmerl elixir
```

## Run

Set the endpoint through the ZUUL environment:

```
mix deps.get
ZUUL=sf iex -S mix  # for ansible.softwarefactory-project.io
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `list_jobs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:list_jobs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/list_jobs](https://hexdocs.pm/list_jobs).
