defmodule CaloriesCounter do
  def top(calories, count \\ 1) do
    calories
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(count)
    |> Enum.sum()
  end
end

defmodule InputSanitizer do
  def sanitize(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
  end
end

ExUnit.start()

defmodule CaloriesCounterTest do
  use ExUnit.Case

  import CaloriesCounter

  @calories [
    [1000, 2000, 3000],
    [4000],
    [5000, 6000],
    [7000, 8000, 9000],
    [10000]
  ]

  test "it returns the elf with the most calories" do
    assert top(@calories) == 24000
  end

  test "it returns the sum of the top n elves with most calories" do
    assert top(@calories, 2) == 35000
  end
end

defmodule InputSanitizerTest do
  use ExUnit.Case

  import InputSanitizer

  @input """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "it returns an array of arrays of integer" do
    expected = [
      [1000, 2000, 3000],
      [4000],
      [5000, 6000],
      [7000, 8000, 9000],
      [10000]
    ]

    assert sanitize(@input) == expected
  end
end

# Start

calories =
  File.read!("input.txt")
  |> InputSanitizer.sanitize()

# Part 1
CaloriesCounter.top(calories) |> IO.inspect(label: "Part 1")

# Part 2
CaloriesCounter.top(calories, 3) |> IO.inspect(label: "Part 2")
