defmodule AoC.Path do

  def run(paths) do
    paths
    |> String.split(", ")
    |> Enum.reduce({0, 0, :north}, fn path, acc -> walk(acc, path) end)
  end

  defp walk({x, y, :north}, "L"<>blocks), do: {x - parse_blocks(blocks), y, :west}
  defp walk({x, y, :south}, "L"<>blocks), do: {x + parse_blocks(blocks), y, :east}

  defp walk({x, y, :east},  "L"<>blocks), do: {x, y + parse_blocks(blocks), :north}
  defp walk({x, y, :west},  "L"<>blocks), do: {x, y - parse_blocks(blocks), :south}

  defp walk({x, y, :north}, "R"<>blocks), do: {x + parse_blocks(blocks), y, :east}
  defp walk({x, y, :south}, "R"<>blocks), do: {x - parse_blocks(blocks), y, :west}

  defp walk({x, y, :east},  "R"<>blocks), do: {x, y - parse_blocks(blocks), :south}
  defp walk({x, y, :west},  "R"<>blocks), do: {x, y + parse_blocks(blocks), :north}

  defp parse_blocks(integer), do: Integer.parse(integer) |> elem(0)
end
