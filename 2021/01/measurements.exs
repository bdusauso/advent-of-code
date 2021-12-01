defmodule Measurements do
  def increases(depths) do
    depths
    |> Enum.with_index()
    |> Enum.count(fn {e, i} -> i > 0 && e > Enum.at(depths, i - 1) end)
  end

  def increases_window(depths) do
    windows =
      for i <- 0..(length(depths) - 3),
        do: Enum.at(depths, i) + Enum.at(depths, i + 1) + Enum.at(depths, i + 2)

    increases(windows)
  end
end

ExUnit.start()

defmodule MeasurementsTest do
  use ExUnit.Case

  test "increases" do
    assert Measurements.increases([1, 3, 2, 4]) == 2
    assert Measurements.increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7
  end

  test "increases_window" do
    assert Measurements.increases([1, 3, 2, 4]) == 1
    assert Measurements.increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 5
  end
end

depths =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

depths
|> Measurements.increases()
|> IO.inspect(label: "Increases (1)")


depths
|> Measurements.increases_window()
|> IO.inspect(label: "Increases (3)")
