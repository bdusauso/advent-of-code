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
    |> dbg()
  end

  defp split_compartments(rucksack) do
    items_in_compartments = div(length(rucksack), 2)
    Enum.chunk_every(rucksack, items_in_compartments)
  end

  defp common_item([list1, list2]) do
    list1 = unique_elems(list1)
    list2 = unique_elems(list2)

    # Find the common elements between the two first lists
    list2
    |> Enum.reduce([], fn item, acc -> if item in list1, do: [item | acc], else: acc end)
    |> List.first()
  end

  defp common_item([list1, list2, list3]) do
    list1 = unique_elems(list1)
    list2 = unique_elems(list2)
    list3 = unique_elems(list3)

    # Find the common elements between the two first lists
    list2
    |> Enum.reduce([], fn item, acc -> if item in list1, do: [item | acc], else: acc end)
    |> Enum.reduce([], fn item, acc -> if item in list3, do: [item | acc], else: acc end)
    |> List.first()
  end

  defp unique_elems(list), do: list |> Enum.sort() |> Enum.uniq()

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
