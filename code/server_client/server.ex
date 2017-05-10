defmodule CounterServer do
  def start do
    pid = spawn(CounterServer, :loop, [0])
    :global.register_name(:counter, pid)
  end

  def loop(counter) do
    receive do
      {:next, sender_pid} ->
        new_counter = counter + 1
        send sender_pid, {:ok_next, new_counter}
        loop(new_counter)
      {:current, sender_pid} ->
        send sender_pid, {:ok_current, counter}
        loop(counter)
    after
      2000 -> IO.puts "Just here, waiting..."
      loop(counter)
    end
  end
end