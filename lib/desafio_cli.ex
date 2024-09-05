defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  def main(_args) do
    Agent.start_link(fn -> %{database: %{}, transactions: []} end, name: __MODULE__)
    loop()
  end

  defp loop do
    IO.write("> ")

    IO.read(:line)
    |> String.trim()
    |> StringUtils.split_with_quotes()
    |> handle_command()

    loop()
  end

  def handle_command([command | args]) do
    command = String.upcase(command)
    # IO.puts("COMMAND: #{command} ARGS: #{inspect(args)}")

    case {command, args} do
      {"BEGIN", []} -> begin()
      {"ROLLBACK", []} -> rollback()
      {"COMMIT", []} -> commit()
      {"GET", [key]} -> get(key)
      {"SET", [key, value]} -> set(key, value)
      {"BEGIN", _} -> IO.puts("ERR \"BEGIN - Syntax error\"")
      {"ROLLBACK", _} -> IO.puts("ERR \"ROLLBACK - Syntax error\"")
      {"COMMIT", _} -> IO.puts("ERR \"COMMIT - Syntax error\"")
      {"SET", _} -> IO.puts("ERR \"SET <chave> <valor> - Syntax error\"")
      {"GET", _} -> IO.puts("ERR \"GET <chave> - Syntax error\"")
      {_, _} -> IO.puts("ERR \"No command #{command}\"")
    end
  end

  def begin do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, :transactions, state.transactions ++ [%{}])
    end)

    num_of_transactions = Agent.get(__MODULE__, fn state -> state.transactions |> length() end)
    IO.puts(num_of_transactions)

    IO.puts("DATABASE: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.database end))
    IO.puts("TRANSACTIONS: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.transactions end))
  end

  def commit do
    num_of_transactions = Agent.get(__MODULE__, fn state -> state.transactions |> length() end)

    case num_of_transactions do
      0 ->
        IO.puts("ERR \"No transaction in progress\"")

      1 ->
        Agent.update(__MODULE__, fn state ->
          %{
            transactions: [],
            database: Map.merge(state.database, List.first(state.transactions))
          }
        end)

      _ ->
        Agent.update(__MODULE__, fn state ->
          last_transaction = List.last(state.transactions)
          remaining_transactions = List.delete_at(state.transactions, -1)

          Map.put(
            state,
            :transactions,
            List.delete_at(remaining_transactions, -1) ++
              [Map.merge(List.last(remaining_transactions), last_transaction)]
          )
        end)
    end

    IO.puts("DATABASE: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.database end))
    IO.puts("TRANSACTIONS: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.transactions end))
  end

  def rollback do
    num_of_transactions = Agent.get(__MODULE__, fn state -> state.transactions |> length() end)

    case num_of_transactions do
      0 ->
        IO.puts("ERR \"No transaction in progress\"")

      _ ->
        Agent.update(__MODULE__, fn state ->
          Map.put(state, :transactions, List.delete_at(state.transactions, -1))
        end)
    end

    IO.puts("DATABASE: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.database end))
    IO.puts("TRANSACTIONS: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.transactions end))
  end

  defp parse_value(arg) do
    cond do
      String.match?(arg, ~r/^-?\d+$/) ->
        String.to_integer(arg)

      String.match?(arg, ~r/^TRUE$/i) ->
        true

      String.match?(arg, ~r/^FALSE$/i) ->
        false

      true ->
        arg
    end
  end

  def set(key, value) do
    parsed_value = parse_value(value)
    exists = Map.get(get_database_with_transactions(), key)

    Agent.update(__MODULE__, fn state ->
      if Enum.empty?(state.transactions) do
        Map.put(state, :database, Map.put(state.database, key, parsed_value))
      else
        last_transaction = List.last(state.transactions)

        Map.put(
          state,
          :transactions,
          List.delete_at(state.transactions, -1) ++ [Map.put(last_transaction, key, parsed_value)]
        )
      end
    end)

    IO.puts(if exists == nil, do: "FALSE #{parsed_value}", else: "TRUE #{parsed_value}")

    IO.puts("DATABASE: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.database end))
    IO.puts("TRANSACTIONS: ")
    IO.inspect(Agent.get(__MODULE__, fn state -> state.transactions end))
  end

  def get(key) do
    value = Map.get(get_database_with_transactions(), key, "NIL")
    IO.puts(value)

    IO.puts("DATABASE WITH TRANSACTIONS: ")
    IO.inspect(get_database_with_transactions())
  end

  def get_database_with_transactions do
    Agent.get(__MODULE__, fn state ->
      transactions_merged =
        state.transactions
        |> Enum.reduce(%{}, fn map, acc ->
          Map.merge(acc, map)
        end)

      final_merged_map = Map.merge(state.database, transactions_merged)

      final_merged_map
    end)
  end
end
