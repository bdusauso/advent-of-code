defmodule ShuttleSearch do
  def earliest(timestamp, ids) do
    {id, departure} =
      ids
      |> Enum.map(fn id -> {id, (div(timestamp, id) + 1) * id - timestamp} end)
      |> Enum.min_by(fn {id, departure} -> departure end)

    id * departure
  end
end

ExUnit.start()

defmodule ShuttleSearchTest do
  use ExUnit.Case

  test "earliest" do
    assert ShuttleSearch.earliest(939, [7, 13, 59, 31, 19]) == 295
  end
end

[timestamp, ids] =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

timestamp = String.to_integer(timestamp)
ids =
  ids
  |> String.split(",")
  |> Enum.reject(&(&1 == "x"))
  |> Enum.map(&String.to_integer/1)

timestamp
|> ShuttleSearch.earliest(ids)
|> IO.inspect(label: "Part 1")
