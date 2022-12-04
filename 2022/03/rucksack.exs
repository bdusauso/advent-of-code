defmodule Rucksack do
  @type t :: list(charlist())

  @priorities Enum.concat(?a..?z, ?A..?Z)

  @spec sum_priorities(t()) :: integer()
  def sum_priorities(rucksacks) do
    rucksacks
    |> Enum.map(&split_compartments/1)
    |> Enum.map(&common_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
    |> dbg()
  end

  def grouped_sum_priorities(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.map(&common_item/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  defp split_compartments(rucksack) do
    items_in_compartments = div(length(rucksack), 2)
    Enum.chunk_every(rucksack, items_in_compartments)
  end

  defp common_item(enumerables) do
    enumerables
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(fn elem, acc -> MapSet.intersection(acc, elem) end)
    |> Enum.to_list()
    |> List.first()
  end

  defp priority(item), do: Enum.find_index(@priorities, &(&1 == item)) + 1
end

ExUnit.start()

defmodule RucksackTest do
  use ExUnit.Case

  test "Gives the sum of the priorities" do
    rucksacks = [
      'vJrwpWtwJgWrhcsFMMfFFhFp',
      'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
      'PmmdzqPrVvPwwTWBwg',
      'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
      'ttgJtRGJQctTZtZT',
      'CrZsJsPPZsGzwwsLwLmpwMDw'
    ]

    assert Rucksack.sum_priorities(rucksacks) == 157
  end
end

input = File.read!("input.txt")

rucksacks =
  input
  |> String.split("\n")
  |> Enum.map(&String.to_charlist/1)

rucksacks
|> Rucksack.sum_priorities()
|> IO.inspect(label: "Part 1")

rucksacks
|> Rucksack.grouped_sum_priorities()
|> IO.inspect(label: "Part 2")
