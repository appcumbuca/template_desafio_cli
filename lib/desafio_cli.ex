defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos passados na linha de
  comando como lista de strings e executa a CLI.
  """
  def main(_args) do
    names = read_names()
    names
    |> count_names()
    |> Enum.each(&IO.puts/1)
  end

  def read_names() do
    Stream.repeatedly(fn -> IO.gets("Digite um nome de um Rei ou Rainha (ou pressione Enter para terminar): ") end)
    |> Enum.take_while(&(&1 != "\n"))  # Lê nomes até uma linha em branco
    |> Enum.map(&String.trim/1)        # Remove espaços em branco
  end

  def count_names(names) do
    names
    |> Enum.frequencies()  # Cria um mapa com a contagem de ocorrências dos nomes
    |> Enum.flat_map(fn {name, count} ->
      Enum.map(1..count, fn n ->
        "#{name} #{integer_to_roman(n)}"
      end)
    end)
  end

  def integer_to_roman(number) do
    roman_numerals = [
      {1000, "M"},
      {900, "CM"},
      {500, "D"},
      {400, "CD"},
      {100, "C"},
      {90, "XC"},
      {50, "L"},
      {40, "XL"},
      {10, "X"},
      {9, "IX"},
      {5, "V"},
      {4, "IV"},
      {1, "I"}
    ]

    roman_numerals
    |> Enum.reduce({number, ""}, fn {value, letter}, {remaining, acc} ->
      {count, remainder} = div_rem(remaining, value)
      {remainder, acc <> String.duplicate(letter, count)}
    end)
    |> elem(1)
  end

  def div_rem(a, b) do
    {div(a, b), rem(a, b)}
  end
end
