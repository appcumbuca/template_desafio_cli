defmodule DesafioCliTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "count_names/1" do
    test "retorna a lista de nomes com numeração romana correta mantendo a ordem original" do
      names = ["Daniel", "Eduardo", "Eduardo", "Maria"]

      assert DesafioCli.count_names(names) == [
        "Daniel I",
        "Eduardo I",
        "Eduardo II",
        "Maria I"
      ]
    end

    test "retorna a lista de nomes com numeração romana para nomes repetidos mantendo a ordem original" do
      names = ["Matheus", "Matheus", "Matheus", "Matheus"]

      assert DesafioCli.count_names(names) == [
        "Matheus I",
        "Matheus II",
        "Matheus III",
        "Matheus IV"
      ]
    end

    test "retorna uma lista com a numeração romana correta para um único nome mantendo a ordem original" do
      names = ["Alice"]

      assert DesafioCli.count_names(names) == ["Alice I"]
    end

    test "retorna uma lista vazia quando a lista de nomes está vazia" do
      names = []

      assert DesafioCli.count_names(names) == []
    end

    test "retorna a lista de nomes com a numeração romana correta para diferentes nomes mantendo a ordem original" do
      names = ["Alice", "Alice", "Alice", "Bob", "Bob"]

      assert DesafioCli.count_names(names) == [
        "Alice I",
        "Alice II",
        "Alice III",
        "Bob I",
        "Bob II"
      ]
    end
  end

  describe "integer_to_roman/1" do
    test "converte números para numerais romanos corretamente" do
      assert DesafioCli.integer_to_roman(1) == "I"
      assert DesafioCli.integer_to_roman(2) == "II"
      assert DesafioCli.integer_to_roman(3) == "III"
      assert DesafioCli.integer_to_roman(4) == "IV"
      assert DesafioCli.integer_to_roman(5) == "V"
      assert DesafioCli.integer_to_roman(9) == "IX"
      assert DesafioCli.integer_to_roman(10) == "X"
      assert DesafioCli.integer_to_roman(11) == "XI"
      assert DesafioCli.integer_to_roman(14) == "XIV"
      assert DesafioCli.integer_to_roman(39) == "XXXIX"
      assert DesafioCli.integer_to_roman(58) == "LVIII"
      assert DesafioCli.integer_to_roman(1994) == "MCMXCIV"
    end
  end
end
