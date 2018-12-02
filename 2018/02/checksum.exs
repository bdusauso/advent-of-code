defmodule Checksum do

  def checksum(ids) do
    {sum_doubles, sum_triples} = 
      ids
      |> Enum.map(&count_duplicates/1)
      |> Enum.reduce({0, 0}, fn {doubles, triples}, {sum_doubles, sum_triples} -> 
        {sum_doubles + doubles, sum_triples + triples} 
      end)
    
    sum_doubles * sum_triples
  end

  def count_duplicates(id) do
    id 
    |> String.codepoints 
    |> Enum.group_by(&(&1))
    |> Enum.reduce({0, 0}, fn {_key, value}, {doubles, triples} -> 
      case length(value) do
        2 -> {1, triples}
        3 -> {doubles, 1}
        _ -> {doubles, triples}
      end
    end)
  end

  def common_letters(ids) do
    ids_subsets = 
      ids
      |> Enum.map(&generate_subsets/1)
      |> List.flatten

    (ids_subsets -- Enum.uniq(ids_subsets)) |> List.first
  end

  def generate_subsets(id) do
    codepoints = String.codepoints(id)
    Enum.map(0..(String.length(id) - 1), &({&1, codepoints |> List.delete_at(&1) |> Enum.join}))
  end
end

ExUnit.start

defmodule ChecksumTest do
  use ExUnit.Case 

  describe "count_duplicates/1" do
    test "no letters that appear exactly two or three times" do
      assert Checksum.count_duplicates("abcdef") == {0, 0}
    end

    test "two a and three b, so it counts for both" do
      assert Checksum.count_duplicates("bababc") == {1, 1}
    end

    test "contains two b, but no letter appears exactly three times" do
      assert Checksum.count_duplicates("abbcde") == {1, 0}
    end

    test "contains three c, but no letter appears exactly two times" do
      assert Checksum.count_duplicates("abcccd") == {0, 1}
    end

    test "contains two a and two d, but it only counts once" do
      assert Checksum.count_duplicates("aabcdd") == {1, 0}
    end

    test "contains three a and three b, but it only counts once" do
      assert Checksum.count_duplicates("ababab") == {0, 1}
    end
  end

  describe "common_letters/1" do
    test "it produces a subset of all ids minus one letter and find the matching ones" do
      ids = ~w(abcde fghij klmno pqrst fguij axcye wvxyz)
      assert Checksum.common_letters(ids) == {2, "fgij"}
    end
  end
end

ids =
  "input.txt"
  |> File.read!
  |> String.split("\n")

IO.puts "Checksum: #{Checksum.checksum(ids)}"
IO.puts "Common letters: #{Checksum.common_letters(ids) |> elem(1)}"
