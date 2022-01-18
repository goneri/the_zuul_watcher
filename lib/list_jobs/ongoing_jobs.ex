defmodule ListJobs.OngoingJobs do
  use Supervisor

  def start_link(_default) do
    Supervisor.start_link(__MODULE__, :ok, name: :ongoing_jobs)
  end

  @impl true
  def init(:ok) do
    children = []

    Supervisor.init(children, strategy: :one_for_one)
  end
end
