defmodule TheZuulWatcher.OngoingJobs do
  use DynamicSupervisor

  def start_link(_default) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker(url, uuid) do
    DynamicSupervisor.start_child(__MODULE__, {TheZuulWatcher.ZuulWebSocket,  [url: url, uuid: uuid]})
  end

  def list_running() do
    Enum.map(DynamicSupervisor.which_children(__MODULE__), fn worker -> get_info(worker) end)
  end

  def get_info({_, pid, :worker, _}) do
    Process.info(pid)
  end

end
