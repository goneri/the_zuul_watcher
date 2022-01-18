defmodule ZuulWebSocket do
  use WebSockex

  def start(url, build_uuid, state) do
    IO.puts("connecting")
    {:ok, pid} = WebSockex.start(url, __MODULE__, state)
    :sys.trace(pid, true)
    WebSockex.send_frame(pid, {:text, "{\"uuid\": \"#{build_uuid}\", \"logfile\": \"console.log\"}"})
    {:ok, pid}
  end

  def handle_frame({type, msg}, state) do
    case type do
      :text ->
        IO.puts("Push to JobOutput")
        #IO.inspect Elixir.ListJobs.JobOutput
        IO.puts("msg -> #{msg}")
        GenServer.cast(ListJobs.JobOutput, {:insert, msg})
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
