defmodule StringUtils do
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
end
