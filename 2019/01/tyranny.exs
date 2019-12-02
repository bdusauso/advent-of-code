defmodule Part1 do
  def fuel(mass), do: round(Float.floor(mass / 3)) - 2
end

defmodule Part2 do
  def fuel(mass) do
    initial_fuel = round(Float.floor(mass / 3)) - 2
    cond do
      initial_fuel > 0 && fuel(initial_fuel) > 0 ->
        initial_fuel + fuel(initial_fuel)

      initial_fuel > 0 ->
        initial_fuel

      true ->
        0
    end
  end
end

ExUnit.start

defmodule Part1Test do
  use ExUnit.Case

  test "fuel/1" do
    assert Part1.fuel(12) == 2
    assert Part1.fuel(14) == 2
    assert Part1.fuel(1969) == 654
    assert Part1.fuel(100756) == 33583
  end
end

defmodule Part2Test do
  use ExUnit.Case

  test "fuel/1" do
    assert Part2.fuel(12) == 2
    assert Part2.fuel(1969) == 966
    assert Part2.fuel(100756) == 50346
  end
end

modules =
  "input.txt"
  |> File.read!()
  |> String.split()
  |> Enum.map(&String.to_integer/1)

modules
|> Enum.map(&Part1.fuel/1)
|> Enum.sum()
|> IO.inspect(label: "Part1")

modules
|> Enum.map(&Part2.fuel/1)
|> Enum.sum()
|> IO.inspect(label: "Part2")
