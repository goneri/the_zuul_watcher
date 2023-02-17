# The Zuul Watcher

The Zuul Watcher connects to a Zuul instance and record the
job output of all the jobs (websocket).

## Requirements

```
sudo dnf install -y erlang erlang-xmerl elixir
```

## Run

Edit `config/config.exs` to adjust your Zuul instance location.

Run the app with:
```
mix deps.get
ZUUL=sf iex -S mix  # for ansible.softwarefactory-project.io
```

The logs are stored in the `./results` directory by default. The application listen on port 3000. You can download the log using an URL with the following format http://my-host:3000/$build_uuid.
