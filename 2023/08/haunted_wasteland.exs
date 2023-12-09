defmodule HauntedWasteland do
  def steps(map, directions, start) do
    steps(map, directions, start, directions, 0)
  end

  defp steps(_map, _directions, "ZZZ", _remaining_directions, steps), do: steps

  defp steps(map, directions, location, [], steps),
    do: steps(map, directions, location, directions, steps)

  defp steps(map, directions, location, [next_dir | rest], steps) do
    next_location = next_direction(map[location], next_dir)
    steps(map, directions, next_location, rest, steps + 1)
  end

  defp next_direction({left, _right}, ?L), do: left

  defp next_direction({_left, right}, ?R), do: right
end

parse_line = ~r/(?<name>\w{3}) = \((?<left>\w{3}), (?<right>\w{3})\)/

[directions, _ | locations] =
  File.stream!("input.txt")
  |> Enum.map(&String.trim/1)

directions = String.to_charlist(directions)

map =
  locations
  |> Enum.map(&Regex.named_captures(parse_line, &1))
  |> Enum.into(%{}, fn %{"name" => name, "left" => left, "right" => right} ->
    {name, {left, right}}
  end)

HauntedWasteland.steps(map, directions, "AAA")
|> IO.inspect(label: "Part 1")
