defmodule Lanternfish do
  def population(lanternfishes, 0), do: lanternfishes
  def population(lanternfishes, days_left) do
    new_population = for l <- lanternfishes, do: if l == 0, do: [6, 8], else: l - 1

    new_population
    |> List.flatten()
    |> population(days_left - 1)
  end
end

lanternfishes =
  "input.txt"
  |> File.read!()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

lanternfishes
|> Lanternfish.population(80)
|> length()
|> IO.inspect(label: "Part 1")
