defmodule TheZuulWatcher.ZuulClient do
  alias Finch.Response
  require Logger

  def api_host do
    Application.fetch_env!(:list_jobs, :api_host)
  end

  def api_path do
    Application.fetch_env!(:list_jobs, :api_path)
  end

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://%{api_host}" => [size: pool_size()]
     }
    }
  end

  def pool_size, do: 25

  def list_finished_jobs() do
    :get
    |> Finch.build("https://#{api_host()}#{api_path()}/builds?limit=30")
    |> Finch.request(__MODULE__)
    |> get_child_item_text()
  end
 
  defp get_child_item_text({:ok, %Response{body: body}}) do
    body
    |> Jason.decode!()
  end

  def show_finished_job(job) do
    case job["result"] do
      nil ->
        Logger.debug("in progress #{job["uuid"]}")
        TheZuulWatcher.OngoingJobs.add_worker("wss://#{api_host()}#{api_path()}/console-stream", job["uuid"])
    end
  end
  
  def show_recent_jobs() do
    jobs = list_finished_jobs()
    Enum.each(jobs, &show_finished_job/1)
  end



   def get_status() do
    :get
    |> Finch.build("https://#{api_host()}#{api_path()}/status")
    |> Finch.request(__MODULE__)
    |> get_child_item_text()
   end
end
