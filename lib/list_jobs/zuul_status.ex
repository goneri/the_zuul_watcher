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


  def list_pipelines() do
    state = GenServer.call(:zuulstatus, :get)
    #IO.inspect state
    state["pipelines"]
  end

  def list_active_pipelines() do
    Enum.filter(list_pipelines(), fn x -> length(x["change_queues"]) > 0  end) 
  end

  def list_change_queues() do
    Enum.flat_map(list_active_pipelines(), fn x -> x["change_queues"] end)
  end

  def list_heads() do
    case length(list_change_queues()) == 0 do
      true -> []
      false ->
        Enum.flat_map(list_change_queues(), fn x -> x["heads"] end)
        |> Enum.reduce([], fn x, acc -> x ++ acc end)
    end
  end

  def list_jobs() do
    Enum.flat_map(list_heads(), fn x -> x["jobs"] end)
    
  end
  
#  def change_queues() do
#    state = GenServer.call(:zuulstatus, :get)
#    #IO.inspect state
#    case list_pipelines() do
#        %{"change_queues" => []}
#      [] ->
#       
#    end
#    change_queues = Enum.flat_map_reduce(state["pipelines"], [], fn x, acc -> {acc ++ x["change_queues"], acc} end)
#  end

  
  
#  def list_jobs() do
#    state = GenServer.call(:zuulstatus, :get)
#    case state["pipelines"]["change_queues"] do
#      [] ->
#        IO.puts("empty")
#      _ ->
#        IO.puts("aa")
#    end
#  end

  
  def list_ongoing_jobs() do
    Enum.filter(list_jobs(), fn x -> x["result"] == nil and x["uuid"] != nil end) 
  end

  def track_ongoing_jobs() do
    Enum.each(list_ongoing_jobs(), &ListJobs.ZuulClient.show_finished_job/1)
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
    Process.send_after(self(), :refresh, 60 * 1000)
  end
end
