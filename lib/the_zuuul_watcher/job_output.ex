defmodule TheZuulWatcher.JobOutput do
  use GenServer
  require Logger

  def results_dir do
    Application.fetch_env!(:list_jobs, :results_dir)
  end

  # Callbacks
  def start_link(_default) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def insert(msg) do
    GenServer.cast(__MODULE__, {:insert, msg})
  end

  @impl true
  def init(stack) do
    schedule_work()
    {:ok, stack}
  end

  @impl true
  def handle_cast({:insert, uuid, msg}, state) do
    {:noreply, [{uuid, msg} | state]}
  end

  def save_results(uuid, data) do
    {:ok, file} = File.open "#{results_dir()}/#{uuid}", [:append, {:delayed_write, 100, 20}]
    IO.binwrite(file, data)
    File.close file
  end

  @impl true
  def handle_info(:work, state) do
    Enum.each(Enum.reverse(state), fn {uuid, msg} -> save_results(uuid, msg) end)
    schedule_work()
    Logger.debug("#{Enum.count(state)} messages saved")
    {:noreply, []}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 2 * 1000)
  end

end
