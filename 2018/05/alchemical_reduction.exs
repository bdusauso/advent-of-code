defmodule AlchemicalReduction do
  def reduce_polymer(polymer) do
    reduce([], polymer) |> Enum.reverse
  end

  def opposite?(a, b) do
    {String.downcase(b), String.upcase(a)} == {a, b} || 
      {String.upcase(b), String.downcase(a)} == {a, b}  
  end

  defp reduce(previous, [a, b | rest]) do
    if opposite?(a, b) do
      case previous do
        []      -> reduce([], rest)
        [h | t] -> reduce(t, [h | rest])
      end
    else
      reduce([a | previous], [b | rest])
    end
  end
  defp reduce(previous, [a]), do: [a | previous]
end

ExUnit.start

defmodule AlchemicalReductionTest do
  use ExUnit.Case, async: false
  import AlchemicalReduction

  describe ".opposite/2" do
    test "A and a are opposite" do
      assert opposite?("A", "a")
    end

    test "a and A are opposite" do
      assert opposite?("a", "A")
    end

    test "A and A are not opposite" do
      refute opposite?("A", "A")
    end

    test "a and a are not opposite" do
      refute opposite?("a", "a")
    end

    test "A and b are not opposite" do
      refute opposite?("A", "b")
    end
  end

  describe ".reduce/1" do
    test "it removes reacting units" do
      expected = String.codepoints("dabCBAcaDA")
      actual = "dabAcCaCBAcCcaDA" |> String.codepoints |> reduce_polymer

      assert actual == expected
    end

    test "bigger units" do
      expected = String.codepoints("i")
      actual = "yZzYilLqQqBbQkKofFOXxjLLllCUuYyVrRvYycJ" |> String.codepoints |> reduce_polymer

      assert actual == expected
    end

    test "reduction on first two units" do
      expected = String.codepoints("aCBAcaDA")
      actual = "cCaCBAcCcaDA" |> String.codepoints |> reduce_polymer

      assert actual == expected
    end
  end
end

"input.txt"
|> File.read!
|> String.trim
|> String.codepoints
|> AlchemicalReduction.reduce_polymer
|> length
|> IO.inspect(label: "Number of units")