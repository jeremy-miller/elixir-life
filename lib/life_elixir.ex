defmodule LifeElixir do
  @moduledoc """
  Controls the Game of Life simulation.
  """

  use GenServer
  import Enum, only: [map: 2, reduce: 3]

  # A cell's `x` and `y` position within the Game of Life board.
  @typep position :: {integer, integer}

  @typep positions :: [position]

  @typep cells :: [pid]

  #############
  # API
  #############

  @doc """
  Start the `LifeElixir` GenServer.
  """
  @spec start_link :: {:ok, pid} | {:error, {:already_started, pid}}
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  `Tick` the Game of Life simulation once.  Calls `Cell.tick/1` on each living cell.
  """
  @spec tick :: :ok
  def tick do
    GenServer.call(__MODULE__, :tick)
  end

  #############
  # Callbacks
  #############

  @spec handle_call(:tick, any, []) :: {:reply, :ok, []}
  def handle_call(:tick, _from, []) do
    get_cells()
    |> tick_cells
    |> wait_for_ticks
    |> consolidate_cell_updates
    |> update_cells
    {:reply, :ok, []}
  end

  @spec get_cells :: cells
  defp get_cells do
    Cell.Supervisor.get_living_cells
  end

  @spec tick_cells(cells) :: list
  defp tick_cells(cells) do
    map(cells, &(Task.async(fn -> Cell.tick(&1) end)))
  end

  @spec wait_for_ticks(list) :: [{positions, cells}]
  defp wait_for_ticks(asyncs) do
    map(asyncs, &Task.await/1)
  end

  @spec consolidate_cell_updates([{positions, cells}]) :: {positions, cells}
  defp consolidate_cell_updates(ticks) do
    reduce(ticks, {[], []}, &consolidate_ticks/2)
  end

  @spec consolidate_ticks({positions, cells}, {[], []}) :: {positions, cells}
  defp consolidate_ticks({create, destroy}, {acc_create, acc_destroy}) do
    {acc_create ++ create, acc_destroy ++ destroy}
  end

  @spec update_cells({positions, cells}) :: list
  defp update_cells({to_create, to_destroy}) do
    map(to_create, &Cell.create/1)
    map(to_destroy, &Cell.destroy/1)
  end
end
