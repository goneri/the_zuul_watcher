defmodule TheZuulWatcher do
  @moduledoc """
  Documentation for `TheZuulWatcher`.
  """


  require Logger

  def list_finished_jobs do
    Logger.info("Listing finished jobs")
    jobs = TheZuulWatcher.ZuulClient.list_finished_jobs()
    IO.inspect(jobs)
  end

end
