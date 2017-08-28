defmodule LifeElixirTest do
  use ExUnit.Case, async: true
  doctest LifeElixir

  test "start_link/0 starts LifeElixir GenServer" do
    {:ok, pid} = GenServer.start(LifeElixir, [])
    assert Process.alive?(pid)
    GenServer.stop(pid)
  end

  test "tick/0 successfully executes" do
    assert LifeElixir.tick == :ok
  end
end
