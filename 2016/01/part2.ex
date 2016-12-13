defmodule AoC.Path do

  def run(paths) do
    paths
    |> String.split(", ")
    |> Enum.reduce([{0, 0, :north}],
        fn path, acc ->
          [walk(hd(acc), path) | acc]
        end)
    |> Enum.reverse
  end

  def duplicates(paths) do
    paths
    |> run
    |> Enum.reduce(%{}, fn location, occurrences -> occurrences |> Map.update(location, 1, &(&1 + 1)) end)
    |> Enum.max_by(&(elem(&1, 1)))
  end

  defp walk({x, y, :north}, "L" <> blocks), do: {x - String.to_integer(blocks), y, :west}
  defp walk({x, y, :south}, "L" <> blocks), do: {x + String.to_integer(blocks), y, :east}

  defp walk({x, y, :east},  "L" <> blocks), do: {x, y + String.to_integer(blocks), :north}
  defp walk({x, y, :west},  "L" <> blocks), do: {x, y - String.to_integer(blocks), :south}

  defp walk({x, y, :north}, "R" <> blocks), do: {x + String.to_integer(blocks), y, :east}
  defp walk({x, y, :south}, "R" <> blocks), do: {x - String.to_integer(blocks), y, :west}

  defp walk({x, y, :east},  "R" <> blocks), do: {x, y - String.to_integer(blocks), :south}
  defp walk({x, y, :west},  "R" <> blocks), do: {x, y + String.to_integer(blocks), :north}

end
