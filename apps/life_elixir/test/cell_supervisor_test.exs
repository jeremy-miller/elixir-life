defmodule CellSupervisorTest do
  use ExUnit.Case, async: true
  import Enum, only: [member?: 2]
  doctest Cell.Supervisor

  test "get_living_cells/0 returns list with one PID" do
    position = {0, 0}
    {:ok, pid} = Supervisor.start_child(Cell.Supervisor, [position])
    # there may be more children in the Cell.Supervisor since these tests
    # are running asynchronously, so just check if our `pid` is one of them.
    assert Cell.Supervisor.get_living_cells == [pid]
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "get_living_cells/0 returns list with two PIDs" do
    position1 = {0, 1}
    position2 = {0, 2}
    {:ok, pid1} = Supervisor.start_child(Cell.Supervisor, [position1])
    {:ok, pid2} = Supervisor.start_child(Cell.Supervisor, [position2])
    assert Cell.Supervisor.get_living_cells, [pid1, pid2]
    Supervisor.terminate_child(Cell.Supervisor, pid1)
    Supervisor.terminate_child(Cell.Supervisor, pid2)
  end

  test "get_living_cell_positions/0 returns one position if only one living cell" do
    position = {0, 15}
    {:ok, pid} = Supervisor.start_child(Cell.Supervisor, [position])
    assert member?(Cell.Supervisor.get_living_cell_positions, %{x: 0, y: 15})
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "get_living_cell_positions/0 returns multiple positions if there are multiple living cells" do
    position1 = {0, 20}
    position2 = {0, 21}
    {:ok, pid1} = Supervisor.start_child(Cell.Supervisor, [position1])
    {:ok, pid2} = Supervisor.start_child(Cell.Supervisor, [position2])
    assert member?(Cell.Supervisor.get_living_cell_positions, %{x: 0, y: 20})
    assert member?(Cell.Supervisor.get_living_cell_positions, %{x: 0, y: 21})
    Supervisor.terminate_child(Cell.Supervisor, pid1)
    Supervisor.terminate_child(Cell.Supervisor, pid2)
  end
end
