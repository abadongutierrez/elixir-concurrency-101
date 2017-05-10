defmodule IATA.Worker do

  @api_key "7a39fc19-a0cb-4915-8cd5-e33ef239ba2c"

  def airports_like(word) do
    result = build_url(word) |> HTTPoison.get |> parse_response
    case result do
      {:ok, data} -> print_data(word, data)
      {:error, reason} -> "Error: #{reason}"
    end
  end

  defp build_url(word) do
    encoded_word = URI.encode(word)
    "http://iatacodes.org/api/v6/autocomplete?api_key=#{@api_key}&query=#{encoded_word}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> get_definitions
  end

  defp parse_response(_) do
    {:error, "Error from service"}
  end

  defp get_definitions(body) do
    cond do
      Map.has_key?(body, "error") -> {:error, body["error"]["message"]}
      true -> {:ok, body["response"]}
    end
  end

  defp print_data(word, data) do
    "Query: #{word}, Airports: [#{Enum.join(print_airports(data["airports"]), ",")}]"
  end

  defp print_airports(data) do
    Enum.map(data, fn(a) ->
      "{Code: #{a["code"]}, Country Name: #{a["country_name"]}, Name: #{a["name"]}}"
    end)
  end

  def loop do
    receive do
      {sender_id, query} ->
        IO.puts "Worker: Recieved message {sender_id, #{query}}"
        send(sender_id, {:ok, airports_like(query)})
      _ ->
        IO.puts "Worker: Ignoring message"
    end
    loop
  end
end
