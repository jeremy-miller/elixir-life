defmodule CellTest do
  use ExUnit.Case, async: true
  import Enum, only: [member?: 2]
  doctest Cell

  test "start_link/1 starts a cell process with name `process` and registers it in the Registry" do
    position = {1, 0}
    {:ok, pid} = Cell.start_link(position)
    assert Registry.lookup(Cell.Registry, position) == [{pid, nil}]
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "start_link/1 returns error if cell at `position` is already started" do
    position = {1, 1}
    {:ok, pid} = Cell.start_link(position)
    assert Cell.start_link(position) == {:error, {:already_started, pid}}
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end
  
  test "create/1 creates a new cell a `position` in the Supervisor" do
    position = {1, 2}
    {:ok, pid} = Cell.create(position)
    # there may be more children in the Cell.Supervisor since these tests
    # are running asynchronously, so just check if our `pid` is one of them.
    assert member?(Supervisor.which_children(Cell.Supervisor), {:undefined, pid, :worker, [Cell]})
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "create/1 returns error if cell with `position` already started" do
    position = {1, 3}
    {:ok, pid} = Cell.create(position)
    assert Cell.create(position) == {:error, {:already_started, pid}}
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  test "destroy/1 terminates the cell with the given `position`" do
    position = {1, 4}
    {:ok, pid} = Cell.create(position)
    assert Cell.destroy(pid) == :ok
  end

  test "destroy/1 returns error if invalid `position` is given" do
    # try terminating the PID running this test,
    # which is not in the Cell.Supervisor
    assert Cell.destroy(self()) == {:error, :not_found}
  end

  test "tick/1 returns no cells to create and its own pid to destroy" do
    position = {1, 6}
    {:ok, pid} = Cell.create(position)
    assert Cell.tick(pid) == {[], [pid]}
    Supervisor.terminate_child(Cell.Supervisor, pid)
  end

  # TODO test with cells to create, none to destory
  # TODO test with no cells to create, none to destroy
  # TODO test with cells to create, cell to destroy
end
