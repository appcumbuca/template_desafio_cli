defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: :database)
  end

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  def main(_args) do
    start_link([])
    loop()
  end

  def split_with_quotes(string) do
    # Regex para dividir a string em palavras, considerando aspas simples e duplas e escapando as aspas
    regex = ~r/'[^'\\]*(?:\\.[^'\\]*)*'|"[^"\\]*(?:\\.[^"\\]*)*"|\S+/

    Regex.scan(regex, string)
    |> List.flatten()
    |> Enum.map(&unescape_quotes/1)
  end

  defp unescape_quotes(str) do
    str
    |> String.replace(~r/^['"]|['"]$/, "")
    |> String.replace("\\'", "'")
    |> String.replace("\\\"", "\"")
  end

  defp loop do
    IO.read(:line)
    |> String.trim()
    |> split_with_quotes()
    |> handle_command()

    loop()
  end

  def handle_command([command | args]) do
    command = String.upcase(command)
    # IO.puts("COMMAND: #{command} ARGS: #{inspect(args)}")

    case {command, args} do
      {"BEGIN", []} -> IO.puts("ERR \"BEGIN - Not implemented\"")
      {"ROLLBACK", []} -> IO.puts("ERR \"ROLLBACK - Not implemented\"")
      {"COMMIT", []} -> IO.puts("ERR \"COMMIT - Not implemented\"")
      {"BEGIN", _} -> IO.puts("ERR \"BEGIN - Syntax error\"")
      {"ROLLBACK", _} -> IO.puts("ERR \"ROLLBACK - Syntax error\"")
      {"COMMIT", _} -> IO.puts("ERR \"COMMIT - Syntax error\"")
      {"GET", [key]} -> get(key)
      {"SET", [key, value]} -> set(key, value)
      {"SET", _} -> IO.puts("ERR \"SET <chave> <valor> - Syntax error\"")
      {"GET", _} -> IO.puts("ERR \"GET <chave> - Syntax error\"")
      {_, _} -> IO.puts("ERR \"No command #{command}\"")
    end
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
    exists = Agent.get(:database, fn db -> Map.get(db, key) end)
    Agent.update(:database, fn db -> Map.put(db, key, parsed_value) end)

    IO.puts(if exists == nil, do: "FALSE #{parsed_value}", else: "TRUE #{parsed_value}")
  end

  def get(key) do
    value = Agent.get(:database, fn db -> Map.get(db, key, "NIL") end)
    IO.puts(value)
  end
end
