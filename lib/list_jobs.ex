defmodule ListJobs do
  @moduledoc """
  Documentation for `ListJobs`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ListJobs.hello()
      :world

  """

  require Logger
  def hello do
    :world
  end

  def list_jobs do
    Logger.info("Listing jobs")
    #jobs = ListJobs.ZuulClient.list_jobs()
    #IO.puts("jobs:")
    #IO.inspect(jobs)
    # {:ok, proc} = GenServer.start_link(ListJobs.JobOutput, [], name: MyStack)
    # IO.inspect proc
    ListJobs.ZuulClient.show_overview()
  end

end
