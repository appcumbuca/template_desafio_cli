defmodule DesafioCliTest do
  use ExUnit.Case
  doctest DesafioCli

  test "greets the world" do
    assert DesafioCli.phrase() == "Hello, world!"
  end
end
