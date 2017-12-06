defmodule AoC do
  def find_recurrent_distribution(banks) do
    Enum.reduce_while(Stream.iterate(0, &(&1)), [banks], fn _, acc ->
      next = redistribute(List.first(acc))
      if next in acc, do: {:halt, acc}, else: {:cont, [next | acc]}
    end)
  end
  
  def redistribute(banks) do
    max  = Enum.max(banks)
    from = Enum.find_index(banks, &(&1 == max))

    _redistribute(List.update_at(banks, from, fn _ -> 0 end), from, max)
  end

  defp _redistribute(banks, _, 0), do: banks
  defp _redistribute(banks, from, to_redistribute) do
    next_index = rem(from + 1, length(banks))
    _redistribute(List.update_at(banks, next_index, &(&1 + 1)), 
                  next_index, 
                  to_redistribute - 1)
  end
end

ExUnit.start

defmodule AoCTest do
  use ExUnit.Case, async: true

  test "redistributing [0 2 7 0]" do
    assert AoC.redistribute([0, 2, 7, 0]) == [2, 4, 1, 2]
  end

  test "redistributing [2 4 1 2]" do
    assert AoC.redistribute([2, 4, 1, 2]) == [3, 1, 2, 3]
  end

  test "redistributing [3 1 2 3]" do
    assert AoC.redistribute([3, 1, 2, 3]) == [0, 2, 3, 4]
  end

  test "redistributing [0 2 3 4]" do
    assert AoC.redistribute([0, 2, 3, 4]) == [1, 3, 4, 1]
  end

  test "redistributing [1 3 4 1]" do
    assert AoC.redistribute([1, 3, 4, 1]) == [2, 4, 1, 2]
  end

  test "find first recurrent distribution" do
    assert AoC.find_recurrent_distribution([0, 2, 7, 0]) |> length == 5
  end

  test "find index of cycle" do
    res = AoC.find_recurrent_distribution([0, 2, 7, 0])
    assert Enum.find_index(res, fn elem -> elem == List.last(res) end) == 4
  end
end

input = [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5]
distributions = input |> AoC.find_recurrent_distribution

# Part 1
distributions 
|> length
|> IO.puts

# Part 2
Enum.find_index(distributions,  &(&1 == distributions |> List.first |> AoC.redistribute)) + 1
|> IO.puts