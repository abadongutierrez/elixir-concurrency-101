defmodule Dictionary.Worker do
  def definition_of(word) do
    result = build_url(word) |> HTTPoison.get |> parse_response
    case result do
      {:ok, definitions} -> print_definitions(definitions)
      :error -> "Error, sorry."
    end
  end

  defp build_url(word) do
    encoded_word = URI.encode(word)
    "http://api.pearson.com/v2/dictionaries/ldoce5/entries?headword=#{encoded_word}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> get_definitions
  end

  defp parse_response(_) do
    :error
  end

  defp get_definitions(body) do
    {:ok, body["results"]}
  end

  defp print_definitions(definitions) do
    IO.puts "#{String.duplicate("-", 20)}"
    Enum.each(definitions, fn(d) ->
      IO.puts "Headword: #{d["headword"]} ->"
      IO.puts ">> Part of speech: #{if d["part_of_speech"], do: d["part_of_speech"], else: ""}"
      if (d["senses"] && Enum.count(d["senses"]) > 0) do
        Enum.each(d["senses"], fn(s) ->
          IO.puts ">> Definition: #{if s["definition"], do: s["definition"], else: ""}"
          IO.puts ">> Examples: #{if s["examples"], do: Enum.join(Enum.map(s["examples"], fn(e) -> e["text"] end), ","), else: "none"}"
        end)
      else
        "Nothing was found."
      end
    end)
    IO.puts "#{String.duplicate("-", 20)}"
  end
end
