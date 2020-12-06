defmodule CustomForms do
  @type group() :: list(String.t())

  @spec groups(list(String.t())) :: list(group())
  def groups(questionnaire) do
    questionnaire
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(List.first(&1) == ""))
  end

  @spec unanimity(list(String.t())) :: non_neg_integer()
  def unanimity(group) do
    group
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.uniq()
    |> length()
  end
end

ExUnit.start()

defmodule CustomFormsTest do
  use ExUnit.Case

  test "unanimity/1" do
    groups = [~w(abc), ~w(a b c), ~w(ab ac), ~w(a a a a), ~w(b)]

    assert Enum.map(groups, &CustomForms.unanimity/1) == [3, 3, 3, 1, 1]
  end
end

"input.txt"
|> File.read!()
|> String.split("\n")
|> CustomForms.groups()
|> Enum.map(&CustomForms.unanimity/1)
|> Enum.sum()
|> IO.inspect(label: "Part 1")
