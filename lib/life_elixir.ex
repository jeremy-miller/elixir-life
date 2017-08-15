defmodule LifeElixir do
  @moduledoc """
  Controls the Game of Life simulation.
  """

  use GenServer

  import Enum, only: [map: 2, reduce: 3]

  #############
  # API
  #############

  @doc """
  Start the `LifeElixir` GenServer.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  `Tick` the Game of Life simulation once.
  """
  def tick do
    GenServer.call(__MODULE__, :tick)
  end

  #############
  # Callbacks
  #############

  @doc """
  Get all living cells and asynchronously call `tick` on each one.
  Wait for all cell ticks to finish.  Create new cells and destroy
  dead cells.

  Always returns `{:reply, :ok, []}`.
  """
  def handle_call(:tick, _from, []) do
    get_cells()
    |> tick_cells
    |> wait_for_ticks
    |> consolidate_cell_updates
    |> update_cells
    {:reply, :ok, []}
  end

  @doc """
  Returns list of PIDs of all living cells.
  """
  defp get_cells, do: Cell.Supervisor.get_living_cells

  @doc """
  Spawn a Task to call `tick` on each cell.

  Returns all spawned Tasks.
  """
  defp tick_cells(cells) do
    map(cells, &(Task.async(fn -> Cell.tick(&1) end)))
  end

  @doc """
  Await all Tasks to finish their cell `ticks`.

  Each cell `tick` retuns `{Cell positions to create, Cell positions to destroy}`
  """
  defp wait_for_ticks(asyncs) do
    map(asyncs, &Task.await/1)
  end

  @doc """
  Consolidates all the returned cell positions into lists of positions to create and destroy.

  Returns a tuple containing two lists:
  1. Cells `to_create`.
  2. Cells `to_destroy`.
  """
  defp consolidate_cell_updates(ticks), do: reduce(ticks, {[], []}, &consolidate_ticks/2)

  @doc """
  Accumulates and de-duplicates the positions returned from all cell `ticks`.
  """
  defp consolidate_ticks({create, destroy}, {acc_create, acc_destroy}) do
    {acc_create ++ create, acc_destroy ++ destroy}
  end

  @doc """
  Creates cells at `to_create` positions and destroys cells at `to_destroy` positions.
  """
  defp update_cells({to_create, to_destroy}) do
    map(to_create, &Cell.create/1)
    map(to_destroy, &Cell.destroy/1)
  end
end
