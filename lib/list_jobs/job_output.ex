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
    IO.puts("Init!")
    IO.inspect self()
    {:ok, stack}
  end

  @impl true
  def handle_cast({:insert, msg}, state) do
    IO.puts("insert message #{msg}")
    {:noreply, [msg | state]}
  end


end
