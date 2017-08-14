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
  Starts the `LifeElixir` GenServer.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Causes the Game of Life simulation to "tick" once.
  """
  def tick do
    GenServer.call(__MODULE__, :tick)
  end

  #############
  # Callbacks
  #############

  def handle_call(:tick, _from, []) do
    get_cells()
    |> tick_cells
    |> wait_for_ticks
    |> consolidate_cell_updates
    |> update_cells
    {:reply, :ok, []}
  end

  defp get_cells, do: Cell.Supervisor.children

  defp tick_cells(cells) do
    map(cells, &(Task.async(fn -> Cell.tick(&1) end)))
  end

  defp wait_for_ticks(asyncs) do
    map(asyncs, &Task.await/1)
  end

  defp consolidate_cell_updates(ticks), do: reduce(ticks, {[], []}, &consolidate_ticks/2)

  defp consolidate_ticks({create, destroy}, {acc_create, acc_destroy}) do
    {acc_create ++ create, acc_destroy ++ destroy}
  end

  defp update_cells({to_create, to_destroy}) do
    map(to_create, &Cell.create/1)
    map(to_destroy, &Cell.destroy/1)
  end
end
