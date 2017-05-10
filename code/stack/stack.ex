defmodule Stack do
  use GenServer

  # Callbacks
  def handle_call(:pop, _from, [head | tail]) do
    # FIX ME! what should I return in order to work correclty?
    # TIP look at the "GenServer callbacks table" to get a clue
  end

  # FIX ME! I need another handle_call to handle :pop when stack is empty
  # TIP look at the "GenServer callbacks table" to get a clue
  # TIP remember that when the stack is empty is an empty list -> []
  # TIP you can match the empty list as an argument for your function just using []

  def handle_cast({:push, item}, state) do
    new_state = [item | state]
    {:noreply, new_state}
  end
end
