defmodule AoC do
  def checksum(matrix, acc_fun) do
    matrix
    |> Enum.reduce(0, &acc_fun.(&1, &2))
  end

  def from_file(file) do
    file
    |> File.read!()
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end
end

input = [[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]]
max_diff = fn (row, acc) -> acc + (Enum.max(row) - Enum.min(row)) end
IO.puts AoC.checksum(input, max_diff)

# Part 1
IO.puts "input.txt" |> AoC.from_file |> AoC.checksum(max_diff)

# Part 2
evenly_divisible? = fn a, b ->
  cond do
    rem(a, b) == 0 -> div(a, b)
    rem(b, a) == 0 -> div(b, a)
    true           -> nil
  end
end

quotient = fn row ->
  row
  |> Enum.find_value(fn dividend ->
    row
    |> List.delete(dividend)
    |> Enum.find_value(&evenly_divisible?.(dividend, &1))
  end)
end

IO.puts quotient.([5, 9, 2, 8])
IO.puts quotient.([9, 4, 7, 3])
IO.puts quotient.([3, 8, 6, 5])

IO.puts "input.txt"
        |> AoC.from_file
        |> AoC.checksum(fn row, sum -> sum + quotient.(row) end)
