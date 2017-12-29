defmodule AoC do
  @regex ~r/(?<name>[a-z]+) \((?<weight>\d+)\)( -> (?<parents>.*))?/

  def extract_info(line) do
    Regex.named_captures(@regex, line)
    |> Map.update!("weight", &String.to_integer/1)
    |> Map.update!("parents", fn x -> if x == "", do: nil, else: String.split(x, ", ") end)
  end

  def find_bottom_of_tower(towers) do
    names   = towers
              |> Enum.map(&(Map.get(&1, "name")))

    parents = towers 
              |> Enum.reduce([], fn towers, acc -> [Map.get(towers, "parents") | acc] end) 
              |> List.flatten 
              |> Enum.filter(&(&1 != nil)) 
    
    (names -- parents) |> List.first
  end
end

ExUnit.start

defmodule AoCTest do
  use ExUnit.Case, async: true

  test "extract info from line with name, weight and parents" do
    line = "usjpp (55) -> cxhms, niixavl, bspsg, htwyil, pyavtyz"
    assert AoC.extract_info(line) == %{
      "name" => "usjpp", 
      "weight" => 55, 
      "parents" => ["cxhms", "niixavl", "bspsg", "htwyil", "pyavtyz"]
    }
  end

  test "extract info from line without parents" do
    line = "tbmiv (77)"
    assert AoC.extract_info(line) == %{
      "name" => "tbmiv", 
      "weight" => 77, 
      "parents" => nil
    }    
  end

  test "find bottom of tower" do
    towers = [
      %{"name" => "pbga", "parents" => nil},
      %{"name" => "xhth", "parents" => nil},
      %{"name" => "ebii", "parents" => nil},
      %{"name" => "havc", "parents" => nil},
      %{"name" => "ktlj", "parents" => nil},
      %{"name" => "fwft", "parents" => ["ktlj", "cntj", "xhth"]},
      %{"name" => "qoyq", "parents" => nil},
      %{"name" => "padx", "parents" => ["pbga", "havc", "qoyq"]},
      %{"name" => "tknk", "parents" => ["ugml", "padx", "fwft"]},
      %{"name" => "jptl", "parents" => nil},
      %{"name" => "ugml", "parents" => ["gyxo", "ebii", "jptl"]},
      %{"name" => "gyxo", "parents" => nil},
      %{"name" => "cntj", "parents" => nil}
    ]

    assert AoC.find_bottom_of_tower(towers) == "tknk"
  end
end

input = "input.txt"
        |> File.read! 
        |> String.trim 
        |> String.split("\n")
        |> Enum.map(&AoC.extract_info/1)

IO.puts AoC.find_bottom_of_tower(input)