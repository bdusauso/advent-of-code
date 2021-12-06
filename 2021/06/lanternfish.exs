defmodule Lanternfish do
  def population(population, 0), do: Enum.sum(population)
  def population(population, days) do
    new_population =
      for i <- 0..7 do
        if i == 6,
          do: List.first(population) + Enum.at(population, 7),
          else: Enum.at(population, i + 1)
      end
    new_population = List.insert_at(new_population, -1, Enum.at(population, 0))

    population(new_population, days - 1)
  end

  def count_per_ages(lanternfishes) do
    Enum.reduce(lanternfishes, [0, 0, 0, 0, 0, 0, 0, 0, 0], fn fish, ages ->
      List.update_at(ages, fish, &(&1 + 1))
    end)
  end
end

ExUnit.start()

defmodule LanternfishTest do
  use ExUnit.Case

  test "population/2" do
    count_per_ages = Lanternfish.count_per_ages([3,4,3,1,2])
    assert Lanternfish.population(count_per_ages, 18) == 26
    assert Lanternfish.population(count_per_ages, 80) == 5934
  end
end

lanternfishes =
  "input.txt"
  |> File.read!()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

count_per_ages = Lanternfish.count_per_ages(lanternfishes)

count_per_ages
|> Lanternfish.population(80)
|> IO.inspect(label: "Part 1")

count_per_ages
|> Lanternfish.population(256)
|> IO.inspect(label: "Part 2")
