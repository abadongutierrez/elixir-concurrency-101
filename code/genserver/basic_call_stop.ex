defmodule Basic do
  use GenServer

  # Clien API

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def stop_replying(pid, message) do
    GenServer.call(pid, {:stop_replying, message})
  end

  def just_stop(pid) do
    GenServer.call(pid, :stop)
  end

  # Server API (callbacks)

  def init(state) do
    {:ok, state}
  end

  def handle_call({:stop_replying, message}, _from, state) do
    {:stop, "Because YOLO", message, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, "Because YOLO", state}
  end
end