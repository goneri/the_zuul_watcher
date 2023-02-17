defmodule TheZuulWatcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def results_dir do
    Application.fetch_env!(:list_jobs, :results_dir)
  end

  @impl true
  def start(_type, _args) do
    children = [
      {TheZuulWatcher.JobOutput, name: ListJobs.JobOutput},
      TheZuulWatcher.ZuulClient.child_spec(),
      TheZuulWatcher.ZuulStatus,
      {DynamicSupervisor, name: TheZuulWatcher.OngoingJobs, strategy: :one_for_one},
      {Plug.Cowboy, scheme: :http, plug: {Plug.Static, at: "/", from: results_dir(), content_types: %{ "*" => "plain/text" }}, options: [port: 3000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TheZuulWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
