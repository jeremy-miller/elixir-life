defmodule Cell do
  @moduledoc """
  Controls an individual cell.
  """

  use GenServer
  import Enum, only: [filter: 2, map: 2]

  @typedoc """
  A cell's `x` and `y` position within the Game of Life board.
  """
  @type position :: {integer, integer}

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
  @spec start_link(position) :: {:ok, pid} | {:error, {:already_started, pid}}
  def start_link(position) do
    via_tuple = {:via, Registry, {Cell.Registry, position}}
    GenServer.start_link(__MODULE__, position, name: via_tuple)
  end

  @doc """
  Start a new `cell` child process in the supervisor, passing `position` as its initial state.
  Will call `Cell.start_link/1`.
  """
  @spec create(position) :: {:ok, pid} | {:error, String.t}
  def create(position) do
    Supervisor.start_child(Cell.Supervisor, [position])
  end

  @doc """
  Remove the given `cell` process (at some `x` and `y` position).
  """
  @spec destroy(position) :: :ok | {:error, String.t}
  def destroy(cell) do
    Supervisor.terminate_child(Cell.Supervisor, cell)
  end

  @doc """
  Tick the given `cell`.  A tick involves calculating which neighboring cells of `cell`
  need to be created, as well as if the `cell` should die.
  """
  @spec tick(atom | pid | {atom, any} | {String.t, atom(), any}) :: any
  def tick(cell) do
    GenServer.call(cell, :tick)
  end

  #############
  # Callbacks
  #############

  @callback handle_call(atom, {pid, term}, position) :: {atom, {[pid], [pid]}, position}
  def handle_call(:tick, _from, position) do
    {:reply, {to_create(position), to_destroy(position)}, position}
  end

  @spec to_create(position) :: [position]
  defp to_create(position) do
    position
    |> get_neighboring_positions
    |> get_dead_neighbors
    |> get_positions_to_create
  end

  @spec get_neighboring_positions(position) :: [position]
  defp get_neighboring_positions({x, y}) do
     @neighbor_offsets
     |> map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  @spec get_dead_neighbors([position]) :: [position]
  defp get_dead_neighbors(positions) do
    filter(positions, &(lookup(&1) == nil))
  end

  @spec lookup(position) :: pid | nil
  defp lookup(position) do
    Cell.Registry
    |> Registry.lookup(position)
    |> map(fn
      {pid, _value} -> pid
      nil -> nil
    end)
    |> filter(&Process.alive?/1)  # make sure we disregard cells which have been removed from the Supervisor, but not from the Registry yet
    |> List.first
  end

  @spec get_positions_to_create([position]) :: [position]
  defp get_positions_to_create(positions) do
    filter(positions, &(count_living_neighbors(&1) == 3))
  end

  @spec count_living_neighbors(position) :: integer
  defp count_living_neighbors(position) do
    position
    |> get_neighboring_positions
    |> get_living_neighbors
    |> length
  end

  @spec get_living_neighbors([position]) :: [position]
  defp get_living_neighbors(positions) do
    filter(positions, &(lookup(&1) != nil))
  end

  @spec to_destroy(position) :: [] | [pid]
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
