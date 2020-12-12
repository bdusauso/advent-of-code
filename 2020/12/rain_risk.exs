defmodule RainRisk do
  @rotations %{0 => "E", 90 => "N", -270 => "N", 180 => "W", -180 => "W", 270 => "S", -90 => "S"}

  def to_tuple(<<direction::8-bitstring, amount::binary>>), do: {direction, String.to_integer(amount)}

  def manhattan_distance(moves, start \\ {0, 0}) do
    {_, {x, y}} = Enum.reduce(moves, {0, start}, fn vector, pos ->
      move(vector, pos)
    end)

    :erlang.abs(x) + :erlang.abs(y)
  end

  def move({"N", amount}, {facing, {x, y}}), do: {facing, {x, y + amount}}
  def move({"S", amount}, {facing, {x, y}}), do: {facing, {x, y - amount}}
  def move({"E", amount}, {facing, {x, y}}), do: {facing, {x + amount, y}}
  def move({"W", amount}, {facing, {x, y}}), do: {facing, {x - amount, y}}
  def move({"L", amount}, {facing, {x, y}}), do: {facing + amount, {x, y}}
  def move({"R", amount}, {facing, {x, y}}), do: {facing - amount, {x, y}}
  def move({"F", amount}, {facing, _} = pos) do
    move({@rotations[rem(facing, 360)], amount}, pos)
  end
end

ExUnit.start()

defmodule RainRiskTest do
  use ExUnit.Case

  test "manhattan distance" do
    assert RainRisk.manhattan_distance([{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]) == 25
  end
end

moves =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&RainRisk.to_tuple/1)

moves
|> RainRisk.manhattan_distance()
|> IO.inspect(label: "Part 1")
