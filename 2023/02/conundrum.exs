defmodule Conundrum do
  @game_number ~r/Game (?<game_number>\d+):\s(?<content>.*)/

  def possible?({r1, g1, b1}, {r2, g2, b2}), do: r1 <= r2 && g1 <= g2 && b1 <= b2

  def parse(line) do
    %{"game_number" => game_number, "content" => content} =
      Regex.named_captures(@game_number, line)

    content =
      Regex.scan(~r/(\d+ green|\d+ red|\d+ blue)/, content)
      |> Enum.map(&List.first/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.reduce({0, 0, 0}, fn [count, color], {r, g, b} ->
        count = String.to_integer(count)

        case color do
          "red" -> {r + count, g, b}
          "green" -> {r, g + count, b}
          "blue" -> {r, g, b + count}
        end
      end)

    {String.to_integer(game_number), content}
  end
end

ExUnit.start()

defmodule ConundrumTest do
  use ExUnit.Case

  test "parse/1" do
    actual =
      [
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
      ]
      |> Enum.map(&Conundrum.parse/1)

    assert actual == [
             {1, {5, 4, 9}},
             {2, {1, 6, 6}},
             {3, {25, 26, 11}},
             {4, {23, 7, 21}},
             {5, {7, 5, 3}}
           ]
  end

  test "possible?/2" do
    actual =
      [
        {5, 4, 9},
        {1, 6, 6},
        {25, 26, 11},
        {23, 7, 21},
        {7, 5, 3}
      ]
      |> Enum.map(&Conundrum.possible?(&1, {12, 13, 14}))

    assert actual == [true, true, false, false, true]
  end
end

input =
  "input.txt"
  |> File.stream!()

input
|> Enum.map(&Conundrum.parse/1)
|> Enum.filter(fn {_, game} -> Conundrum.possible?(game, {12, 13, 14}) end)
|> Enum.map(&elem(&1, 0))
|> Enum.sum()
|> dbg()
|> IO.inspect(label: "Part 1")

# [
#   "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
#   "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
#   "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
#   "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
#   "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
# ]
# |> Enum.map(&Conundrum.parse/1)
# |> Enum.filter(fn {_, game} -> Conundrum.possible?(game, {12, 13, 14}) end)
# |> Enum.map(&elem(&1, 0))
# |> Enum.sum()
# |> IO.inspect()
