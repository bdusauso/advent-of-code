defmodule AoC do
  @regex ~r/(?<name>[a-z]+) \((?<weight>\d+)\)( -> (?<parents>.*))?/

  def extract_info(line) do
    Regex.named_captures(@regex, line)
    |> Map.update!("weight", &String.to_integer/1)
    |> Map.update!("parents", &(String.split(&1, ", ")))
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
end