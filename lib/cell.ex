defmodule Cell do
  @moduledoc false

  use GenServer
  import Enum, only: [filter: 2, map: 2]

  @neighbor_offsets [
    {-1, -1}, { 0, -1}, { 1, -1},
    {-1,  0},           { 1,  0},
    {-1,  1}, { 0,  1}, { 1,  1},
  ]

  # API

  def start_link(position) do
    GenServer.start_link(__MODULE__, position, name: {
      :via, Registry, {Cell.Registry, position}
    })
  end

  def create(position) do
    Supervisor.start_child(Cell.Supervisor, [position])
  end

  def destroy(cell) do
    Supervisor.terminate_child(Cell.Supervisor, cell)
  end

  def tick(cell) do
    GenServer.call(cell, :tick)
  end

  def count_neighbors(cell) do
    GenServer.call(cell, :count_neighbors)
  end

  # Callbacks

  def handle_call(:tick, _from, position) do
    {:reply, {to_create(position), to_destroy(position)}, position}
  end

  def handle_call(:count_living_neighbors, _from, position) do
    {:reply, count_living_neighbors(position), position}
  end

  defp to_create(position) do
    position
    |> get_neighboring_positions
    |> get_dead_neighbors
    |> get_positions_to_create
  end

  defp get_neighboring_positions({x, y}) do
     @neighbor_offsets
     |> map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  defp get_dead_neighbors(positions), do: filter(positions, &(lookup(&1) == nil))

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

  defp get_positions_to_create(positions) do
    positions
    |> filter(&(count_living_neighbors(&1) == 3))
  end

  defp count_living_neighbors(position) do
    position
    |> get_neighboring_positions
    |> get_living_neighbors
    |> length
  end

  defp get_living_neighbors(positions), do: filter(positions, &(lookup(&1) != nil))

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
