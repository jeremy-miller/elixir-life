defmodule Pattern do
  @moduledoc """
  Defines available starting live cell configurations.
  """

  @doc """
  Returns a diehard methuselah configuration based at the given `x` and `y`.
  """
  def diehard(x, y) do
    [
                                                      {6, 2},
      {0, 1}, {1, 1},
              {1, 0},                         {5, 0}, {6, 0}, {7, 0},
    ]
    |> translate(x, y)
  end

  defp translate(positions, x, y) do
    positions
    |> Enum.map(fn {cx, cy} -> {x + cx, y + cy} end)
  end
end
