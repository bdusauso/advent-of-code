defmodule Measurements do
  def increases(depths, window_size \\ 1) do
    windows =
      depths
      |> Enum.chunk_every(window_size, 1, :discard)
      |> Enum.map(&Enum.sum/1)

    windows
    |> Enum.with_index()
    |> Enum.count(fn {e, i} -> i > 0 && e > Enum.at(windows, i - 1) end)
  end
end

ExUnit.start()

defmodule MeasurementsTest do
  use ExUnit.Case

  test "increases with default size of 1" do
    assert Measurements.increases([1, 3, 2, 4]) == 2
    assert Measurements.increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7
  end

  test "increases with window size of 3" do
    assert Measurements.increases([1, 3, 2, 4], 3) == 1
    assert Measurements.increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], 3) == 5
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
|> Measurements.increases(3)
|> IO.inspect(label: "Increases (3)")
