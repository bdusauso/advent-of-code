defmodule BagProcessing do
  @type bag_color() :: String.t()
  @type bag_content() :: list({pos_integer(), String.t()})
  @type bag_specifications() :: %{bag_color() => bag_content()}

  @content_regex ~r/(\d)\s(\w+\s\w+)/
  @bag_regex ~r/\w+\s\w+/

  @spec expand_specs(bag_specifications()) :: %{bag_color() => list(bag_color())}
  def expand_specs(specifications) do
    specifications
    |> Enum.map(fn {c, s} -> {c, expand_specs(specifications, s, [])} end)
    |> Enum.into(%{})
  end

  def expand_specs(_, [], acc), do: Enum.reverse(acc)
  def expand_specs(specs, bags, acc) do
    bags
    |> Enum.flat_map(fn {_, c} -> expand_specs(specs, specs[c], [c | acc]) end)
    |> Enum.uniq()
  end

  @spec to_specs(list(String.t())) :: bag_specifications()
  def to_specs(lines) do
    lines
    |> String.split(".\n", trim: true)
    |> Enum.map(&to_spec/1)
    |> Enum.into(%{})
  end

  @spec to_spec(String.t()) :: {bag_color(), bag_content()}
  def to_spec(line) do
    content =
      @content_regex
      |> Regex.scan(line, capture: :all_but_first)
      |> Enum.map(fn [count, bag] -> {String.to_integer(count), bag} end)

    bag =
      @bag_regex
      |> Regex.run(line)
      |> List.first()

    {bag, content}
  end
end

ExUnit.start()

defmodule BagProcessingTest do
  use ExUnit.Case

  @specs %{
    "light red" => [{1, "bright white"}, {2, "muted yellow"}],
    "dark orange" => [{3, "bright white"}, {4, "muted yellow"}],
    "bright white" => [{1, "shiny gold"}],
    "muted yellow" => [{2, "shiny gold"}, {9, "faded blue"}],
    "shiny gold" => [{1, "dark olive"}, {2, "vibrant plum"}],
    "dark olive" => [{3, "faded blue"}, {4, "dotted black"}],
    "vibrant plum" => [{5, "faded blue"}, {6, "dotted black"}],
    "faded blue" => [],
    "dotted black" => []
  }

  test "expanded specs" do
    assert BagProcessing.expand_specs(@specs, @specs["light red"], []) ==
      ["bright white", "shiny gold", "dark olive", "faded blue", "dotted black", "vibrant plum", "muted yellow"]
  end
end

specs =
  "input.txt"
  |> File.read!()
  |> BagProcessing.to_specs()

specs
|> BagProcessing.expand_specs()
|> Enum.count(fn {_, contents} -> "shiny gold" in contents end)
|> IO.inspect(label: "Part 1")
