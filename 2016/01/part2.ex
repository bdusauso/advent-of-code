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
    paths
    |> run
    |> Enum.reduce(%{}, fn location, occurrences -> occurrences |> Map.update(location, 1, &(&1 + 1)) end)
    |> Enum.max_by(&(elem(&1, 1)))
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
