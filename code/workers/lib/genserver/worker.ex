defmodule GenServer.IATA.Worker do
  use GenServer # defines the callbacks required by GenServer

  @api_key "7a39fc19-a0cb-4915-8cd5-e33ef239ba2c"

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts) # it invokes init
  end

  def airports_like(pid, word) do
    GenServer.call(pid, {:airports_like, word})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:airports_like, word}, from, stats) do
    case airports_like(word) do
      {:ok, data} ->
        {:reply, print_data(word, data), stats}
      _ ->
        {:reply, :error, stats}
    end
  end

  ## functions

  def airports_like(word) do
    build_url(word) |> HTTPoison.get |> parse_response
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

end