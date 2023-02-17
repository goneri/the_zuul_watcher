defmodule TheZuulWatcher.ZuulWebSocket do
  use WebSockex
  require Logger

  def start_link(url: url, uuid: uuid) do
    state = %{"uuid" => uuid}
    name = String.to_atom("build-#{uuid}")
    {:ok, pid} = WebSockex.start_link(url, __MODULE__, state, [name: name])
    #:sys.trace(pid, true)
    {:ok, _} = WebSockex.send_frame(pid, {:text, "{\"uuid\": \"#{uuid}\", \"logfile\": \"console.log\"}"})
    {:ok, pid}
  end

  def handle_frame({type, msg}, state) do
    case type do
      :text ->
        GenServer.cast(TheZuulWatcher.JobOutput, {:insert, state["uuid"], msg})
      _ ->
          Logger.error("WebSocket/unexpected message - Type: #{inspect type} -- Message: #{inspect msg}")
    end
    {:ok, state}
  end

  def handle_call({:send, {type, msg} = frame}, state) do
    Logger.debug("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  def terminate(reason, state) do
    Logger.info("\nSocket Terminating:\n#{inspect reason}\n\n#{inspect state}\n")
    exit(:normal)
  end
end
