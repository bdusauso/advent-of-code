defmodule DivePart1 do
  def move({h, v}, ["forward", x]), do: {h + x, v}
  def move({h, v}, ["down", x]), do: {h, v + x}
  def move({h, v}, ["up", x]), do: {h, v - x}
end

moves =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split/1)
  |> Enum.map(fn [dir, amount] -> [dir, String.to_integer(amount)] end)

{h, v} = Enum.reduce(moves, {0, 0}, fn move, pos -> DivePart1.move(pos, move) end)
IO.inspect(h * v, label: "Part1")
