input =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

defmodule Traversal do
  def tree_count(map, {right, down}) do
    length =
      map
      |> List.first()
      |> String.length()

    map
    |> Enum.take_every(down)
    |> Enum.with_index()
    |> Enum.count(fn {line, num} -> String.at(line, rem(num * right, length)) == "#" end)
  end
end

ExUnit.start()

defmodule TraversalTest do
  use ExUnit.Case

  @map [
    "..##.......",
    "#...#...#..",
    ".#....#..#.",
    "..#.#...#.#",
    ".#...##..#.",
    "..#.##.....",
    ".#.#.#....#",
    ".#........#",
    "#.##...#...",
    "#...##....#",
    ".#..#...#.#"
  ]

  for {{r, d} = dir, expected} <- [
    {{1, 1}, 2},
    {{3, 1}, 7},
    {{5, 1}, 3},
    {{7, 1}, 4},
    {{1, 2}, 2}
  ] do
    test "Going #{r} right and #{d} down returns #{expected}" do
      assert Traversal.tree_count(@map, unquote(dir)) == unquote(expected)
    end
  end
end

input
|> Traversal.tree_count({3, 1})
|> IO.inspect(label: "Part 1")

[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
|> Enum.reduce(1, fn dir, product -> Traversal.tree_count(input, dir) * product end)
|> IO.inspect(label: "Part 2")
