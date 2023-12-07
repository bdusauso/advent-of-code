defmodule BoatRace do
  def above_record(time, distance) do
    Enum.map(0..time, &(&1 * (time - &1)))
    |> Enum.filter(&(&1 > distance))
  end
end

[{48, 261}, {93, 1192}, {84, 1019}, {66, 1063}]
|> Enum.map(fn {time, distance} -> BoatRace.above_record(time, distance) end)
|> Enum.reduce(1, fn records, product -> product * length(records) end)
|> IO.inspect(label: "Part 1")

BoatRace.above_record(48_938_466, 261_119_210_191_063)
|> length()
|> IO.inspect(label: "Part 2")
