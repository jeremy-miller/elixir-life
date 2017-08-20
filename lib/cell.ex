defmodule Cell do
  @moduledoc """
  Controls an individual cell.
  """

  use GenServer
  import Enum, only: [filter: 2, map: 2]

  # The offsets surrounding each cell.
  # credo:disable-for-lines:4
  @neighbor_offsets [
    {-1, -1}, { 0, -1}, { 1, -1},
    {-1,  0},           { 1,  0},
    {-1,  1}, { 0,  1}, { 1,  1},
  ]

  #############
  # API
  #############

  @doc """
  Start a cell and register it in the Registry, using the `position` as its name.
  """
  def start_link(position) do
    via_tuple = {:via, Registry, {Cell.Registry, position}}
    GenServer.start_link(__MODULE__, position, name: via_tuple)
  end

  @doc """
  Start a new `cell` child process in the supervisor, passing `position` as its initial state.
  Will call `start_link` above.
  """
  def create(position) do
    Supervisor.start_child(Cell.Supervisor, [position])
  end

  @doc """
  Remove the given `cell` (position) process.
  """
  def destroy(cell) do
    Supervisor.terminate_child(Cell.Supervisor, cell)
  end

  @doc """
  Tick the given `cell`.
  """
  def tick(cell) do
    GenServer.call(cell, :tick)
  end

  #############
  # Callbacks
  #############

  # Calculate neighboring cells to create, and whether the current cell should die.
  def handle_call(:tick, _from, position) do
    {:reply, {to_create(position), to_destroy(position)}, position}
  end

  # Get the neighboring positions of `position`, filter out the dead neighbors,
  # then get the cell positions which should be created and return them.
  defp to_create(position) do
    position
    |> get_neighboring_positions
    |> get_dead_neighbors
    |> get_positions_to_create
  end

  # Get all `{x, y}` coordinates of neighboring cells based on the input `{x, y}` and return them.
  defp get_neighboring_positions({x, y}) do
     @neighbor_offsets
     |> map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  # Filter out the `positions` which are not currently alive and return them.
  defp get_dead_neighbors(positions) do
    filter(positions, &(lookup(&1) == nil))
  end

  # Lookup `position` in the Cell Registry. If it's in the Registry, get the process's `pid`.
  # Make sure the cell with PID `pid` is alive, and if so, return it.
  # Filter out `alive` processes since `terminate_child` will remove the cell from the Supervisor,
  # but it may not be fully removed from the Registry yet.
  defp lookup(position) do
    Cell.Registry
    |> Registry.lookup(position)
    |> map(fn
      {pid, _value} -> pid
      nil -> nil
    end)
    |> filter(&Process.alive?/1)
    |> List.first
  end

  # Filter out `positions` and return ones should be created (i.e. have 3 living neighbors).
  defp get_positions_to_create(positions) do
    positions
    |> filter(&(count_living_neighbors(&1) == 3))
  end

  # Get the neighbors of `position`, filter out living neighbors, and return the count.
  defp count_living_neighbors(position) do
    position
    |> get_neighboring_positions
    |> get_living_neighbors
    |> length
  end

  # Returns a filtered list of all living positions within `positions`.
  defp get_living_neighbors(positions) do
    filter(positions, &(lookup(&1) != nil))
  end

  # Get the living neighbors of `position`.  If there are exactly 2 or 3, this `position`
  # lives, otherwise it will be destroyed.
  # Returns itself if it should be destroyed, otherwise returns an empty list.
  defp to_destroy(position) do
    position
    |> count_living_neighbors
    |> case do
      2 -> []
      3 -> []
      _ -> [self()]
    end
  end
end
