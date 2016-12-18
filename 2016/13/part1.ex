defmodule AoC.Maze do

  @input 1364

  defp math_expression({x, y}) do
    (x * x) + (3 * x) + (2 * x * y) + (y * y)
  end

  def count_number_of_set_bits(number) do
    count_number_of_set_bits(number, 0)
  end

  defp count_number_of_set_bits(0,      acc), do: acc
  defp count_number_of_set_bits(number, acc), do: count_number_of_set_bits(div(number, 2), acc + rem(number, 2))

end
