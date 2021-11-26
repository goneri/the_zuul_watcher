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

  def lib_jobs do
    Logger.info("Listing jobs")
    #jobs = ListJobs.ZuulClient.list_jobs()
    #IO.puts("jobs:")
    #IO.inspect(jobs)
    ListJobs.ZuulClient.show_overview()
  end

end
