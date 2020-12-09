defmodule Encoding do
  def first_error(numbers, size) do
    {preamble, rest} = Enum.split(numbers, size)

    res =
      Enum.reduce_while(rest, {size, preamble}, fn num, {idx, preamble} ->
        invalids = for i <- preamble, j <- preamble, i != j, i + j == num, do: {i, j}
        if Enum.empty?(invalids),
          do: {:halt, {:invalid, num}},
          else: {:cont, {idx + 1, Enum.slice(numbers, idx + 1 - size, size)}}
      end)

    case res do
      {:invalid, num} -> num
      _ -> nil
    end
  end

  # Totally suboptimal !
  def encryption_weakness(numbers, size) do
    error = first_error(numbers, size)
    candidates = for i <- 0..(length(numbers) - 1),
                     j <- 2..(length(numbers) - 1 - i),
                     Enum.slice(numbers, i, j) |> Enum.sum() == error do
      Enum.slice(numbers, i, j)
    end

    candidates
    |> List.flatten()
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
  end
end

ExUnit.start()

defmodule EncodingTest do
  use ExUnit.Case

  @numbers [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
  @preamble_size 5

  test "first error" do
    assert Encoding.first_error(@numbers, @preamble_size) == 127
  end

  test "encryption weakness" do
    assert Encoding.encryption_weakness(@numbers, @preamble_size) == 62
  end
end

numbers =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

numbers
|> Encoding.first_error(25)
|> IO.inspect(label: "Part1")

numbers
|> Encoding.encryption_weakness(25)
|> IO.inspect(label: "Part2")
