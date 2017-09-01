defmodule Interface.LifeChannel do
  use Phoenix.Channel

  def join("life", _, socket) do
    Cell.Supervisor.get_living_cells
    |> Enum.map(&Cell.destroy(&1))

    Pattern.diehard(20, 20)
    |> Enum.map(&Cell.create(&1))

    {:ok, %{positions: Cell.Supervisor.get_living_cell_positions}, socket}
  end
  
  def handle_in("tick", _, socket) do
    LifeElixir.tick

    broadcast!(socket, "tick", %{positions: Cell.Supervisor.get_living_cell_positions})

    {:noreply, socket}
  end
end
