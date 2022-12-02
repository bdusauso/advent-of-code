input = "A Y\nB X\nC Z"

defmodule Part1 do
  def sanitize(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(fn [opponent, _, response] -> {response - 23, opponent} end)
  end

  def play({hand, hand}), do: score(hand, :draw)
  def play({?A, ?B}), do: score(?A, :lose)
  def play({?A, ?C}), do: score(?A, :win)
  def play({?B, ?A}), do: score(?B, :win)
  def play({?B, ?C}), do: score(?B, :lose)
  def play({?C, ?A}), do: score(?C, :lose)
  def play({?C, ?B}), do: score(?C, :win)

  defp score(shape, result), do: shape_score(shape) + round_score(result)

  defp shape_score(?A), do: 1
  defp shape_score(?B), do: 2
  defp shape_score(?C), do: 3

  defp round_score(:win), do: 6
  defp round_score(:draw), do: 3
  defp round_score(:lose), do: 0
end

defmodule Part2 do
  def sanitize(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(fn [opponent, _, result] -> {opponent, result} end)
  end

  def play({?A, ?X}), do: score(?C, :lose)
  def play({?B, ?X}), do: score(?A, :lose)
  def play({?C, ?X}), do: score(?B, :lose)
  def play({?B, ?Y}), do: score(?B, :draw)
  def play({?C, ?Y}), do: score(?C, :draw)
  def play({?A, ?Y}), do: score(?A, :draw)
  def play({?A, ?Z}), do: score(?B, :win)
  def play({?B, ?Z}), do: score(?C, :win)
  def play({?C, ?Z}), do: score(?A, :win)

  defp score(shape, result), do: shape_score(shape) + round_score(result)

  defp shape_score(?A), do: 1
  defp shape_score(?B), do: 2
  defp shape_score(?C), do: 3

  defp round_score(:win), do: 6
  defp round_score(:draw), do: 3
  defp round_score(:lose), do: 0
end

ExUnit.start()

defmodule Part1Test do
  use ExUnit.Case

  import Part1

  test "returns an array of tuples" do
    input = "A Y\nB X\nC Z"

    assert sanitize(input) == [{?B, ?A}, {?A, ?B}, {?C, ?C}]
  end
end

File.read!("input.txt")
|> Part1.sanitize()
|> Enum.map(&Part1.play/1)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

File.read!("input.txt")
|> Part2.sanitize()
|> Enum.map(&Part2.play/1)
|> Enum.sum()
|> IO.inspect(label: "Part 2")
