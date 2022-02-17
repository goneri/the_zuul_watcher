defmodule TheZuulWatcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: TheZuulWatcher.Worker.start_link(arg)
      # {TheZuulWatcher.Worker, arg}
      {TheZuulWatcher.JobOutput, name: ListJobs.JobOutput},
      TheZuulWatcher.ZuulClient.child_spec(),
      TheZuulWatcher.ZuulStatus,
      {DynamicSupervisor, name: TheZuulWatcher.OngoingJobs, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TheZuulWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
