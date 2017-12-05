defmodule AoC do
  def jumps_count(offsets, update_fun) do
    _jumps_count(offsets, 0, 0, update_fun)
  end

  defp _jumps_count(offsets, count, index, update_fun) do
    # IO.puts "offsets: #{inspect(offsets)}, index: #{index}, count: #{count}"
    if index < 0 || index >= length(offsets) do
      count
    else
      _jumps_count(List.update_at(offsets, index, update_fun), count + 1, index + Enum.at(offsets, index), update_fun)
    end
  end
end

ExUnit.start

defmodule AoCTest do
  use ExUnit.Case, async: true

  test "number of jumps for [0 3  0  1  -3] should be 5 when increment is 1" do
    assert AoC.jumps_count([0, 3, 0, 1, -3], &(&1 + 1)) == 5
  end    

  test "number of jumps for [0 3  0  1  -3] should be 5 when increment is -1 if offset >= 3 and +1 otherwise" do
    assert AoC.jumps_count([0, 3, 0, 1, -3], 
                           fn offset -> if offset >= 3, do: offset - 1, else: offset + 1 end) == 10
  end    
end

input = "input.txt" 
        |> File.read! 
        |> String.trim 
        |> String.split("\n") 
        |> Enum.map(&String.to_integer/1)

input |> AoC.jumps_count(&(&1 + 1))
      |> IO.inspect(label: "Part 1")

input |> AoC.jumps_count(fn offset -> if offset >= 3, do: offset - 1, else: offset + 1 end)
      |> IO.inspect(label: "Part 2")
