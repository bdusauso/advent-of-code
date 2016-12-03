defmodule Triangle do

  def possibles_count(triangles) do
    triangles
    |> Enum.map(fn sides -> apply(Triangle, :possible, sides) end)
    |> Enum.filter(fn e -> e end)
    |> length
  end

  def possible(a, b, c), do: a + b > c && b + c > a && c + a > b

end
