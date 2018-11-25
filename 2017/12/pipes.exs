defmodule Day12 do
  def group_links_count(mapping, destination) do
    mapping
    |> group_links(Map.fetch!(mapping, destination), [destination])
    |> length
  end
  
  def groups_count(mapping) do
    mapping
    |> Map.keys
    |> Enum.map(&(group_links(mapping, Map.fetch!(mapping, &1), [&1])))
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq
    |> length
  end

  defp group_links(_mapping, [], processed), do: processed
  defp group_links(mapping, [current | rest], processed) do
    processed = if Enum.member?(processed, current), do: processed, else: [current | processed]
    to_process = rest ++ (mapping |> Map.fetch!(current) |> Enum.reject(&(Enum.member?(processed, &1))))

    group_links(mapping, to_process, processed)
  end
end

ExUnit.start

defmodule Day12Test do
  use ExUnit.Case
  import Day12

  @mappings %{
    "0" => ["2"],
    "1" => ["1"],
    "2" => ["0", "3", "4"],
    "3" => ["2", "4"],
    "4" => ["2", "3", "6"],
    "5" => ["6"],
    "6" => ["4", "5"]
  }

  test "group_links_count/2" do
    assert group_links_count(@mappings, "0") == 6
  end

  test "group_count/1" do
    assert groups_count(@mappings) == 2
  end
end

mapping = 
  "input.txt"
  |> File.read!() 
  |> String.split("\n") 
  |> Enum.map(&String.split(&1, " <-> ")) 
  |> Enum.reduce(%{}, fn [idx | links], acc -> Map.put_new(acc, idx, links |> List.first |> String.split(", ")) end)

IO.puts "Links count for group: #{Day12.group_links_count(mapping, "0")}"
IO.puts "Groups count: #{Day12.groups_count(mapping)}"