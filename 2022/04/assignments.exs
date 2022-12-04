defmodule Assignments do
  def fully_contains?(%Range{} = a, %Range{} = b) do
    a.first >= b.first && a.last <= b.last
  end

  def overlapping?(%Range{} = a, %Range{} = b) do
    !Range.disjoint?(a, b)
  end

  def count_fully_contained(assignment_pairs) do
    Enum.count(assignment_pairs, fn {a, b} -> fully_contains?(a, b) || fully_contains?(b, a) end)
  end

  def count_overlapping(assignment_pairs) do
    Enum.count(assignment_pairs, fn {a, b} -> overlapping?(a, b) end)
  end
end

ExUnit.start()

defmodule AssignmentsTest do
  use ExUnit.Case

  import Assignments

  setup do
    assignments = [
      {2..4, 6..8},
      {2..3, 4..5},
      {5..7, 7..9},
      {2..8, 3..7},
      {6..6, 4..6},
      {2..6, 4..8}
    ]

    {:ok, %{assignments: assignments}}
  end

  describe "fully_contains?/2" do
    test "it returns true if the first range is fully contained within the second one" do
      assert fully_contains?(3..7, 2..8) == true
    end

    test "it returns false otherwise" do
      assert fully_contains?(2..8, 3..7) == false
      assert fully_contains?(2..4, 6..8) == false
      assert fully_contains?(6..8, 2..4) == false
    end
  end

  describe "count_fully_contained/1" do
    test "returns the number of assignments that a fully contained within the other in a pair", %{
      assignments: assignments
    } do
      assert count_fully_contained(assignments) == 2
    end
  end

  describe "count_overlapping/1" do
    test "returns the number of assignments overlapping the other in a pair", %{
      assignments: assignments
    } do
      assert count_overlapping(assignments) == 4
    end
  end
end

assignment_pairs = ~r/(?<a1>\d+)-(?<a2>\d+),(?<b1>\d+)-(?<b2>\d+)/

# Parsing the input into a list of tuples containing ranges
assignment_pairs =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(fn pairs -> Regex.named_captures(assignment_pairs, pairs) end)
  |> Enum.map(&Enum.map(&1, fn {k, v} -> {k, String.to_integer(v)} end))
  |> Enum.map(fn [{"a1", a1}, {"a2", a2}, {"b1", b1}, {"b2", b2}] -> {a1..a2, b1..b2} end)

assignment_pairs
|> Assignments.count_fully_contained()
|> IO.inspect(label: "Part 1")

assignment_pairs
|> Assignments.count_overlapping()
|> IO.inspect(label: "Part 2")
