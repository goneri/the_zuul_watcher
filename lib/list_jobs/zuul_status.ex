defmodule ListJobs.ZuulStatus do
  use GenServer

  def api_host do
    "ansible.softwarefactory-project.io"
  end
  def api_path do
    "/zuul/api"
  end


  def get() do
    GenServer.call(:zuulstatus, :get)
  end

  def zuul_version() do
    state = GenServer.call(:zuulstatus, :get)
    state["zuul_version"]
  end

  def inspect() do
    state = GenServer.call(:zuulstatus, :get)
    IO.inspect state
  end


  def list_pipelines(state) do
    state["pipelines"]
  end

  def list_active_pipelines(pipelines) do
    Enum.filter(pipelines, fn x -> length(x["change_queues"]) > 0  end)
  end

  def list_change_queues(active_pipelines) do
    Enum.flat_map(active_pipelines, fn x -> x["change_queues"] end)
  end

  def list_heads(change_queues) do
    Enum.flat_map(change_queues, fn x -> x["heads"] end)
    |> Enum.reduce([], fn x, acc -> x ++ acc end)
  end

  def list_jobs(heads) do
    Enum.flat_map(heads, fn x -> x["jobs"] end)
  end

  def list_ongoing_jobs(jobs) do
    Enum.filter(jobs, fn x -> x["result"] == nil and x["uuid"] != nil end)
  end

  def track_ongoing_jobs(state) do
    state
    |> list_pipelines
    |> list_active_pipelines
    |> list_change_queues
    |> list_heads
    |> list_jobs
    |> list_ongoing_jobs
    |> Enum.each(&ListJobs.ZuulClient.show_finished_job/1)
  end


  def start_link(_default) do
    state = ListJobs.ZuulClient.get_status()
    GenServer.start_link(__MODULE__, state, name: :zuulstatus)
  end

  @impl true
  def init(state) do
    schedule_refresh()
    {:ok, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    new_state = ListJobs.ZuulClient.get_status()
    schedule_refresh() # Reschedule once more
    case new_state do
      %{"zuul_version" => zuul_version} ->
        IO.puts("Zuul version: #{zuul_version}")
        track_ongoing_jobs(new_state)
        {:noreply, new_state}
      _ ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, 10 * 1000)
  end
end
