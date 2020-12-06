defmodule CustomForms do
  @type group() :: list(String.t())

  @spec groups(list(String.t())) :: list(group())
  def groups(questionnaire) do
    questionnaire
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(List.first(&1) == ""))
  end

  @spec anyone(list(String.t())) :: non_neg_integer()
  def anyone(group) do
    group
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.uniq()
    |> length()
  end

  @spec everyone(list(String.t())) :: non_neg_integer()
  def everyone(group) do
    group
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, count} -> count == length(group) end)
  end
end

ExUnit.start()

defmodule CustomFormsTest do
  use ExUnit.Case

  test "anyone/1" do
    groups = [~w(abc), ~w(a b c), ~w(ab ac), ~w(a a a a), ~w(b)]

    assert Enum.map(groups, &CustomForms.anyone/1) == [3, 3, 3, 1, 1]
  end

  test "everyone/1" do
    groups = [~w(abc), ~w(a b c), ~w(ab ac), ~w(a a a a), ~w(b)]

    assert Enum.map(groups, &CustomForms.everyone/1) == [3, 0, 1, 1, 1]
  end
end

groups =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> CustomForms.groups()

groups
|> Enum.map(&CustomForms.anyone/1)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

groups
|> Enum.map(&CustomForms.everyone/1)
|> Enum.sum()
|> IO.inspect(label: "Part 2")
