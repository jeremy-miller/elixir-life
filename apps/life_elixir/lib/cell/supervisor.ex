defmodule Cell.Supervisor do
  @moduledoc false

  use Supervisor
  import Enum, only: [map: 2]

  @typep cells :: [pid]

  @doc false
  @spec start_link :: {:ok, pid}
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc false
  @spec init(any) :: no_return
  def init(_) do
    children = [
      worker(Cell, [])
    ]
    opts = [strategy: :simple_one_for_one, name: Cell.Supervisor, restart: :transient]
    supervise(children, opts)
  end

  @doc """
  Get all cells which the supervisor is supervising.
  Returns a list of PIDs.
  """
  @spec get_living_cells :: cells
  def get_living_cells do
    Cell.Supervisor
    |> Supervisor.which_children
    |> map(fn {_, pid, _, _} -> pid end)
  end

  @doc """
  Return `{x: _, y: _}` struct of position for each living cell.
  """
  @spec get_living_cell_positions :: [%{x: integer, y: integer}]
  def get_living_cell_positions do
    get_living_cells()
    |> Enum.map(&Cell.position/1)
    |> Enum.map(fn {x, y} -> %{x: x, y: y} end)
  end
end
