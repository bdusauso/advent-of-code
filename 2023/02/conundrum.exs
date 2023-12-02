defmodule Conundrum do
  @game_number ~r/Game (?<game_number>\d+):\s(?<content>.*)/

  def possible?(game, {r2, g2, b2}) do
    Enum.all?(game, fn {r1, g1, b1} -> r1 <= r2 && g1 <= g2 && b1 <= b2 end)
  end

  def minimum(game) do
    minimums =
      for i <- 0..2,
          do:
            game
            |> Enum.map(&elem(&1, i))
            |> Enum.max()

    List.to_tuple(minimums)
  end

  def power({r, g, b}), do: r * g * b

  def parse(line) do
    %{"game_number" => game_number, "content" => content} =
      Regex.named_captures(@game_number, line)

    content =
      content
      |> String.split("; ")
      |> Enum.map(&String.split(&1, ~r/,?\s/))
      |> Enum.map(&Enum.chunk_every(&1, 2))
      |> Enum.map(&to_subsets/1)

    {String.to_integer(game_number), content}
  end

  defp to_subsets(game) do
    Enum.reduce(game, {0, 0, 0}, fn [count, color], {r, g, b} ->
      count = String.to_integer(count)

      case color do
        "red" -> {count, g, b}
        "green" -> {r, count, b}
        "blue" -> {r, g, count}
      end
    end)
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
             {1, [{4, 0, 3}, {1, 2, 6}, {0, 2, 0}]},
             {2, [{0, 2, 1}, {1, 3, 4}, {0, 1, 1}]},
             {3, [{20, 8, 6}, {4, 13, 5}, {1, 5, 0}]},
             {4, [{3, 1, 6}, {6, 3, 0}, {14, 3, 15}]},
             {5, [{6, 3, 1}, {1, 2, 2}]}
           ]
  end

  test "possible?/2" do
    actual =
      [
        [{4, 0, 3}, {1, 2, 6}, {0, 2, 0}],
        [{0, 2, 0}, {1, 3, 4}, {0, 1, 1}],
        [{20, 8, 6}, {4, 13, 5}, {1, 5, 0}],
        [{3, 1, 6}, {6, 3, 0}, {14, 3, 15}],
        [{6, 3, 1}, {1, 2, 2}]
      ]
      |> Enum.map(&Conundrum.possible?(&1, {12, 13, 14}))

    assert actual == [true, true, false, false, true]
  end

  test "minimum/1" do
    assert Conundrum.minimum([{4, 0, 3}, {1, 2, 6}, {0, 2, 0}]) == {4, 2, 6}
  end

  test "power/1" do
    assert Conundrum.power({4, 2, 6}) == 48
  end
end

games =
  "input.txt"
  |> File.stream!()
  |> Enum.map(&Conundrum.parse/1)

games
|> Enum.filter(fn {_, game} -> Conundrum.possible?(game, {12, 13, 14}) end)
|> Enum.map(&elem(&1, 0))
|> Enum.sum()
|> IO.inspect(label: "Part 1")

games
|> Enum.map(&elem(&1, 1))
|> Enum.map(&Conundrum.minimum/1)
|> Enum.map(&Conundrum.power/1)
|> Enum.sum()
|> IO.inspect(label: "Part 2")
