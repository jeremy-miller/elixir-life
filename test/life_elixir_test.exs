defmodule LifeElixirTest do
  use ExUnit.Case, async: true
  doctest LifeElixir

  test "tick/0 successfully executes" do		
    assert LifeElixir.tick == :ok		
  end
end
