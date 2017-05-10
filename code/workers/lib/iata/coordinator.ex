defmodule IATA.Coordinator do
  def loop(results \\ [], expected_results) do
    IO.puts "Expected results: #{expected_results}"
    receive do
      {:ok, result} ->
        IO.puts "Coordinator: Recieved message {:ok, result}"
        new_results = [result | results]
        if (expected_results == Enum.count(new_results)) do
          send self, :exit
        end
        loop(new_results, expected_results)
      :exit ->
        IO.puts "Coordinator: Recieved message :exit"
        IO.puts(results |> Enum.join(",\n"))
      _ ->
        loop(results, expected_results)
    end
  end
end