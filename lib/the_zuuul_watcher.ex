defmodule TheZuulWatcher do
  @moduledoc """
  Documentation for `TheZuulWatcher`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TheZuulWatcher.hello()
      :world

  """

  require Logger
  def hello do
    :world
  end

  def list_jobs do
    Logger.info("Listing jobs")
    #jobs = TheZuulWatcher.ZuulClient.list_jobs()
    #IO.puts("jobs:")
    #IO.inspect(jobs)
    # {:ok, proc} = GenServer.start_link(TheZuulWatcher.JobOutput, [], name: MyStack)
    # IO.inspect proc
    TheZuulWatcher.ZuulClient.show_overview()
  end

end
