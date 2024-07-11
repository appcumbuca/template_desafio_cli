defmodule DesafioCliTest do
  use ExUnit.Case
  doctest DesafioCli

  test "greets the world" do
    assert DesafioCli.hello() == :world
  end
end
