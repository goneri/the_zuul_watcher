defmodule ZuulWebSocket do
  use WebSockex

  def start(url, build_uuid, state) do
    IO.puts("connecting")
    IO.inspect(state)
    {:ok, pid} = WebSockex.start(url, __MODULE__, state)
    :sys.trace(pid, true)
    IO.inspect(pid)
    WebSockex.send_frame(pid, {:text, "{\"uuid\": \"#{build_uuid}\", \"logfile\": \"console.log\"}"})
    {:ok, pid}
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
