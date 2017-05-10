defmodule CounterClient do
  def next do
    counter_pid = :global.whereis_name(:counter)
    send counter_pid, {:next, self()}
    receive do
      {:ok_next, counter} -> IO.puts "Next is #{counter}"
    after
      1000 -> "No answer from server."
    end
  end

  def current do
    counter_pid = :global.whereis_name(:counter)
    send counter_pid, {:current, self()}
    receive do
      {:ok_current, counter} -> IO.puts "Current is #{counter}"
    after
      1000 -> "No answer from server."
    end
  end
end