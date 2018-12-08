defmodule MemoryManeuver do

  def metadata_sum([]), do: 0
  def metadata_sum([0, metadata_length | rest]) do 
    # IO.puts "Child count: 0, metadata count: #{metadata_length}, rest: #{inspect(rest)}"
    sum = rest |> Enum.take(metadata_length) |> Enum.sum
    sum + metadata_sum(Enum.drop(rest, metadata_length))
  end
  def metadata_sum([child_count, metadata_length | rest]) do
    # IO.puts "Child count: #{child_count}, metadata count: #{metadata_length}, rest: #{inspect(rest)}"
    sum = rest |> Enum.reverse |> Enum.take(metadata_length) |> Enum.sum
    sum + metadata_sum(Enum.take(rest, length(rest) - metadata_length))  
  end 
end

ExUnit.start

defmodule MemoryManeuverTest do
  use ExUnit.Case
  import MemoryManeuver

  describe "metadata_sum/1" do
    test "empty tree" do
      assert metadata_sum([]) == 0
    end
    
    test "no subtree" do
      tree = [0, 3, 10, 11, 12]
      assert metadata_sum(tree) == 33
    end
    
    test "one subtree and one level of depth" do
      tree = [1, 3, 0, 4, 1, 2, 1, 4, 1, 2, 3]  
      assert metadata_sum(tree) == 14
    end

    test "with two subtrees and one level of depth" do
      tree = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]
      assert metadata_sum(tree) == 138
    end

    test "without metadata" do
      assert metadata_sum([0, 0]) == 0
    end

    test "with multiple subtrees and level of depths" do
      g = [0, 1, 6]
      f = [1, 2, g, 2, 3]
      e = [0, 1, 5]
      d = [0, 3, 1, 2, 3]
      c = [3, 0, d, e, f]
      b = [0, 2, 3, 4]
      a = [2, 1, b, c, 5]

      tree = List.flatten(a)
      assert metadata_sum(tree) == 34
    end
  end
end

tree =
  "input.txt"
  |> File.read!
  |> String.trim
  |> String.split
  |> Enum.map(&String.to_integer/1)

tree 
|> MemoryManeuver.metadata_sum 
|> IO.inspect(label: "Metadata sum")