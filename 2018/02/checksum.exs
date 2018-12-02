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
end

ids =
  "input.txt"
  |> File.read!
  |> String.split("\n")

IO.puts Checksum.checksum(ids)