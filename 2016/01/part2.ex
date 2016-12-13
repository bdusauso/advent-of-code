defmodule AoC.Path do

  def run(paths) do
    paths
    |> String.split(", ")
    |> Enum.reduce([{0, 0, :north}],
        fn path, acc ->
          acc ++ walk(List.last(acc), path)
        end)
  end

  def duplicates(paths) do
    locations = paths |> run |> Enum.map(fn {x, y, _} -> {x, y} end)
    locations
    |> Enum.with_index
    |> Enum.reduce(:none, fn {current, idx}, acc ->
        case acc do
          :none -> locations |> first_duplicate(current, idx)
          found -> found
        end
      end)
  end

  def first_duplicate(list, element, index) do
    case list |> Enum.drop(index + 1) |> Enum.find(&(&1 == element)) do
      nil -> :none
      idx -> element
    end
  end

  defp walk({x, y, :north}, "L" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x - b, y, :west}
  defp walk({x, y, :south}, "L" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x + b, y, :east}

  defp walk({x, y, :east},  "L" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x, y + b, :north}
  defp walk({x, y, :west},  "L" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x, y - b, :south}

  defp walk({x, y, :north}, "R" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x + b, y, :east}
  defp walk({x, y, :south}, "R" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x - b, y, :west}

  defp walk({x, y, :east},  "R" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x, y - b, :south}
  defp walk({x, y, :west},  "R" <> blocks), do: for b <- 1..String.to_integer(blocks), do:  {x, y + b, :north}

end
