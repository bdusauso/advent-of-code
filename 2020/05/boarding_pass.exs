defmodule BoardingPass do
  def seat(partition) do
    partition
    |> String.replace(~w(F B L R), &replacement/1)
    |> row_column()
  end

  def seat_id({row, col}), do: row * 8 + col
  def seat_id(partition), do: partition |> seat() |> seat_id()

  defp replacement("B"), do: "1"
  defp replacement("F"), do: "0"
  defp replacement("R"), do: "1"
  defp replacement("L"), do: "0"

  defp row_column(partition) do
    {row, col} = String.split_at(partition, 7)
    {String.to_integer(row, 2), String.to_integer(col, 2)}
  end
end

ExUnit.start()

defmodule BoardingPassTest do
  use ExUnit.Case

  test "seat/1" do
    assert BoardingPass.seat("FBFBBFFRLR") == {44, 5}
  end
end

passes =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

passes
|> Enum.map(&BoardingPass.seat_id/1)
|> Enum.max()
|> IO.inspect(label: "Part 1")

passes
|> Enum.map(&BoardingPass.seat/1)
|> Enum.reduce(%{}, fn {row, _} = seat, statuses -> Map.update(statuses, row, [seat], &([seat | &1])) end)
|> Enum.reject(fn {_, seats} -> length(seats) == 8 end)
|> IO.inspect(label: "Part 2")
