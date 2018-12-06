defmodule AlchemicalReduction do
  def reduce_polymer(polymer) do
    polymer
    |> String.codepoints
    |> reduce([])
    |> Enum.reverse
    |> Enum.join
  end

  def shortest_reduction(polymer) do
    ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    |> Stream.map(fn unit -> polymer |> String.replace(unit, "") |> String.replace(String.upcase(unit), "") end)
    |> Stream.map(&reduce_polymer/1)
    |> Stream.map(&String.length/1)
    |> Enum.min
  end

  def opposite?(a, b) do
    {String.downcase(b), String.upcase(a)} == {a, b} ||
      {String.upcase(b), String.downcase(a)} == {a, b}
  end

  defp reduce([a, b | rest], previous) do
    if opposite?(a, b) do
      case previous do
        []      -> reduce(rest, [])
        [h | t] -> reduce([h | rest], t)
      end
    else
      reduce([b | rest], [a | previous])
    end
  end
  defp reduce([a], previous), do: [a | previous]
  defp reduce([], previous), do: previous
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
      expected = "dabCBAcaDA"
      actual = reduce_polymer("dabAcCaCBAcCcaDA")

      assert actual == expected
    end

    test "bigger units" do
      expected = "i"
      actual = reduce_polymer("yZzYilLqQqBbQkKofFOXxjLLllCUuYyVrRvYycJ")

      assert actual == expected
    end

    test "reduction on first two units" do
      expected = "aCBAcaDA"
      actual = reduce_polymer("cCaCBAcCcaDA")

      assert actual == expected
    end

    test "reduction on short opposites" do
      assert reduce_polymer("cbaABC") == ""
    end
  end
end

units =
  "input.txt"
  |> File.read!
  |> String.trim

units
|> AlchemicalReduction.reduce_polymer
|> String.length
|> IO.inspect(label: "Number of units")

units
|> AlchemicalReduction.shortest_reduction
|> IO.inspect(label: "Shortest reduction")
