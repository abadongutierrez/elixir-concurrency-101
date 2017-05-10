defmodule Basic do
  use GenServer

  # Clien API

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def reply_after(pid, seconds) do
    GenServer.call(pid, {:reply_after, seconds}, 1_000 * (seconds + 1))
  end

  # Server API (callbacks)

  def init(state) do
    {:ok, state}
  end

  def handle_call({:reply_after, seconds}, from, state) do
    Process.send_after(self(), {:reply, from, seconds}, 1_000 * seconds)
    {:noreply, state}
  end

  def handle_info({:reply, from, seconds}, state) do
    GenServer.reply(from, "Reply after #{seconds} seconds")
    {:noreply, state}
  end
end