defmodule ShuttleSearch do
  def earliest(timestamp, ids) do
    ids = Enum.reject(ids, &(&1 == 0))

    {id, departure} =
      ids
      |> Enum.map(fn id -> {id, (div(timestamp, id) + 1) * id - timestamp} end)
      |> Enum.min_by(fn {_, departure} -> departure end)

    id * departure
  end

  def earliest_offset(ids, start \\ 0) do
    {step, offset, ids} =
      ids
      |> offset_to_max()
      # |> IO.inspect()

    start
    |> Stream.iterate(&(&1 + step))
    |> Stream.take_while(&!match_offsets?(&1, ids))
    |> Enum.to_list()
    |> List.last()
    |> Kernel.+(step)
    |> Kernel.-(offset)
  end

  def match_offsets?(number, ids) do
    # IO.inspect(number)
    Enum.all?(ids, fn {id, offset} -> rem(number + offset, id) == 0 end)
  end

  def offset_to_max(ids) do
    max = Enum.max(ids)
    max_index = Enum.find_index(ids, &(&1 == max))

    ids_with_offsets =
      ids
      |> Enum.with_index()
      |> Enum.map(fn {elem, cur_pos} -> {elem, cur_pos - max_index} end)
      |> Enum.reject(&(elem(&1, 0) == 0))

    {max, max_index, ids_with_offsets}
  end
end

ExUnit.start()

defmodule ShuttleSearchTest do
  use ExUnit.Case
  import ShuttleSearch

  test "earliest" do
    assert earliest(939, [7, 13, 59, 31, 19]) == 295
  end

  test "earliest offset" do
    assert earliest_offset([7, 13, 0, 0, 59, 0, 31, 19]) == 1068781
  end

  test "match offsets ?" do
    assert match_offsets?(1068781, [{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}])
  end

  test "offset_to_max/1" do
    assert offset_to_max([7, 13, 0, 0, 59, 0, 31, 19]) == {59, 4, [{7, -4}, {13, -3}, {59, 0}, {31, 2}, {19, 3}]}
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
  |> Enum.map(&String.replace(&1, "x", "0"))
  |> Enum.map(&String.to_integer/1)

timestamp
|> ShuttleSearch.earliest(ids)
|> IO.inspect(label: "Part 1")

ids
|> ShuttleSearch.earliest_offset(100000000000000)
|> IO.inspect(label: "Part 2")
