defmodule LifeElixir.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(LifeElixir, []),
      supervisor(Cell.Supervisor, []),
      supervisor(Registry, [:unique, Cell.Registry])
    ]
    opts = [strategy: :one_for_one, name: LifeElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
