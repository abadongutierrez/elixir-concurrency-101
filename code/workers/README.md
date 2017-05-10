# Workers

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `workers` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:workers, "~> 0.1.0"}]
    end
    ```

  2. Ensure `workers` is started before your application:

    ```elixir
    def application do
      [applications: [:workers]]
    end
    ```

