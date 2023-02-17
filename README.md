# The Zuul Watcher

The Zuul Watcher connects to a Zuul instance and record the
job output of all the jobs (websocket).

The application will that:

1. poll the status page to list the ongoing jobs (every 10s)
2. open a Websocket for reach of these jobs
3. redirect the Websocket content to a local file in the ./results directory
4. expose the log over HTTP, (e.g: http://my-host:3000/$build_uuid)

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
