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

  # Get all living cells and asynchronously call `tick` on each one.
  # Wait for all cell ticks to finish, then create new cells and destroy dead cells.
  def handle_call(:tick, _from, []) do
    get_cells()
    |> tick_cells
    |> wait_for_ticks
    |> consolidate_cell_updates
    |> update_cells
    {:reply, :ok, []}
  end

  # Returns list of PIDs of all living cells.
  defp get_cells do
    Cell.Supervisor.get_living_cells
  end

  # Spawn a Task to call `tick` on each cell.
  # Returns a list of all spawned Tasks.
  defp tick_cells(cells) do
    map(cells, &(Task.async(fn -> Cell.tick(&1) end)))
  end

  # Await all Tasks to finish their cell `ticks`.
  # Each cell `tick` retuns `{[cell positions to create], [cell positions to destroy]}`.
  # `[cell positions to destroy]` is either the cell which just ticked, or an empty list.
  defp wait_for_ticks(asyncs) do
    map(asyncs, &Task.await/1)
  end

  # Consolidates all the returned cell positions into lists of positions to create and destroy.
  # Returns `{[cell positions to create], [cell positions to destroy]}`.
  defp consolidate_cell_updates(ticks) do
    reduce(ticks, {[], []}, &consolidate_ticks/2)
  end

  defp consolidate_ticks({create, destroy}, {acc_create, acc_destroy}) do
    {acc_create ++ create, acc_destroy ++ destroy}
  end

  # Creates cells at `to_create` positions and destroys cells at `to_destroy` positions.
  defp update_cells({to_create, to_destroy}) do
    map(to_create, &Cell.create/1)
    map(to_destroy, &Cell.destroy/1)
  end
end
