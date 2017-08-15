defmodule Cell.Supervisor do
  @moduledoc false
  
  use Supervisor
  
  import Enum, only: [map: 2]

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

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
  def get_living_cells do
    Cell.Supervisor
    |> Supervisor.which_children
    |> map(fn {_, pid, _, _} -> pid end)
  end
end
