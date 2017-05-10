defmodule IATA do
  def autocomplete(words) do
    coordinator_pid = spawn(IATA.Coordinator, :loop, [[], Enum.count(words)])
    IO.puts "Spawned the Coordinator process"

    words |> Enum.each(fn(word) ->
      worker_pid = spawn(IATA.Worker, :loop, [])
      IO.puts "Spawned a Worker process for [#{word}]"
      send(worker_pid, {coordinator_pid, word})
    end)
  end
end