defmodule ListJobs.ZuulWebSocket do
  use WebSockex

  def start_link(url: url, uuid: uuid) do
    IO.puts("connecting - start_link")
    IO.inspect String.to_atom("build-#{uuid}")
    state = %{"uuid" => uuid}
    name = String.to_atom("build-#{uuid}")
    IO.puts("Starting #{name}")
    {:ok, pid} = WebSockex.start_link(url, __MODULE__, state, [name: name])
    #:sys.trace(pid, true)
    {:ok, _} = WebSockex.send_frame(pid, {:text, "{\"uuid\": \"#{uuid}\", \"logfile\": \"console.log\"}"})
    {:ok, pid}
  end

  def handle_frame({type, msg}, state) do
    case type do
      :text ->
        GenServer.cast(ListJobs.JobOutput, {:insert, state["uuid"], msg})
      _ ->
          IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    end
    {:ok, state}
  end

  def handle_call({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  def terminate(reason, state) do
    IO.puts("\nSocket Terminating:\n#{inspect reason}\n\n#{inspect state}\n")
    exit(:normal)
  end
end
