defmodule CellSupervisorTest do
  use ExUnit.Case, async: true
  doctest Cell.Supervisor

  test "get_living_cells/0 returns empty list" do
    assert Cell.Supervisor.get_living_cells == []
  end

  test "get_living_cells/0 returns list with one PID" do
    position = {0, 0}
    {:ok, pid} = Supervisor.start_child(Cell.Supervisor, [position])
    assert Cell.Supervisor.get_living_cells == [pid]
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "get_living_cells/0 returns list with two PIDs" do
    position1 = {0, 1}
    position2 = {0, 2}
    {:ok, pid1} = Supervisor.start_child(Cell.Supervisor, [position1])
    {:ok, pid2} = Supervisor.start_child(Cell.Supervisor, [position2])
    assert Cell.Supervisor.get_living_cells == [pid1, pid2]
    Supervisor.terminate_child(Cell.Supervisor, pid1)
    Supervisor.terminate_child(Cell.Supervisor, pid2)
  end
end
