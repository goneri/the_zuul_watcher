defmodule ListJobs.ZuulClient do
  alias Finch.Response

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://dashboard.zuul.ansible.com" => [size: pool_size()]
     }}
  end

  def pool_size, do: 25

  def list_jobs() do
    :get
    |> Finch.build("https://dashboard.zuul.ansible.com/api/tenant/ansible/builds?limit=30")
    |> Finch.request(__MODULE__)
    |> get_child_item_text()
  end
  
  def get_item(item_id) do
    :get
    |> Finch.build("https://hacker-news.firebaseio.com/v0/item/#{item_id}.json")
    |> Finch.request(__MODULE__)
  end

  defp get_child_item_text({:ok, %Response{body: body}}) do
    body
    |> Jason.decode!()
  end

  def show_job(job) do
    case job["result"] do
      "SUCCESS" -> true
#        IO.puts("success")
#        IO.puts(job["uuid"])
      nil ->
        IO.puts("in progress")
        IO.puts(job["uuid"])
        IO.puts(job["result"])
        {:ok, pid} = ZuulWebSocket.start("wss://dashboard.zuul.ansible.com/api/tenant/ansible/console-stream", job["uuid"], %{debug: [:trace]})
    end
  end
  
  def show_overview() do
    jobs = list_jobs()
    Enum.each(jobs, &show_job/1)
  end
end
