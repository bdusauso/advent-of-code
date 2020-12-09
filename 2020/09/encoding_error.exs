defmodule Encoding do
  def first_error(numbers, size) do
    {preamble, rest} = Enum.split(numbers, size)
    res =
      Enum.reduce_while(rest, {size, preamble}, fn num, {idx, preamble} ->
        invalids = for i <- preamble, j <- preamble, i != j, i + j == num, do: {i, j}

        IO.inspect(invalids, label: "Invalids")

        if Enum.empty?(invalids),
          do: {:halt, {:invalid, num}},
          else: {:cont, {idx + 1, Enum.slice(numbers, idx + 1 - size, size)}}
      end)

    case res do
      {:invalid, num} -> num
      _ -> nil
    end
  end
end

ExUnit.start()

defmodule EncodingTest do
  use ExUnit.Case

  test "first error" do
    numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
    assert Encoding.first_error(numbers, 5) == 127
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
