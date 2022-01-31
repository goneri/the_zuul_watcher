defmodule ListJobs.JobOutput do
  use GenServer


  # Callbacks
  def start_link(_default) do
    IO.puts("JobOutput start_link #{__MODULE__}")
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
    {:ok, file} = File.open "#{uuid}.log", [:append, {:delayed_write, 100, 20}]
    IO.binwrite(file, data)
    File.close file
  end

  @impl true
  def handle_info(:work, state) do
    Enum.each(Enum.reverse(state), fn {uuid, msg} -> save_results(uuid, msg) end)
    schedule_work()
    IO.puts("#{Enum.count(state)} messages saved")
    {:noreply, []}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 2 * 1000)
  end

end
