defmodule Basic do
  use GenServer

  # Clien API

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def add_num(pid, num) do
    GenServer.call(pid, {:add_num, num})
  end

  def sum(pid) do
    GenServer.call(pid, :sum)
  end

  def print_from(pid) do
    GenServer.call(pid, :from)
  end

  # Server API (callbacks)

  def init(state) do
    {:ok, state}
  end

  def handle_call({:add_num, num}, _from, state) do
    {:reply, :ok, [num | state]}
  end

  def handle_call(:sum, _from, state) do
    {:reply, Enum.reduce(state, 0, fn(x, acc) -> x + acc end), state}
  end

  def handle_call(:from, from, state) do
    {:reply, from, state}
  end
end