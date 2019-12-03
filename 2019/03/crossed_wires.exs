defmodule Part1 do
  def closest_intersection(wire1, wire2) do
    wire1
    |> intersections(wire2)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&taxicab_distance({0, 0}, &1))
    |> Enum.sort(&(&1 <= &2))
    |> Enum.reject(&(&1 == 0))
    |> List.first()
  end

  def path_to_coordinates(path) do
    Enum.reduce(path, [{0, 0}], fn step, acc ->
      {x, y} = List.last(acc)
      {x1, y1} = step_to_displacement(step)
      List.insert_at(acc, -1, {x + x1, y + y1})
    end)
  end

  def step_to_displacement("R" <> dist), do: {String.to_integer(dist), 0}
  def step_to_displacement("L" <> dist), do: {-String.to_integer(dist), 0}
  def step_to_displacement("U" <> dist), do: {0, String.to_integer(dist)}
  def step_to_displacement("D" <> dist), do: {0, -String.to_integer(dist)}

  def taxicab_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def intersections(wire1, wire2) do
    wire1 = path_to_coordinates(wire1)
    wire2 = path_to_coordinates(wire2)

    segments1 = Enum.zip(wire1, Enum.drop(wire1, 1))
    segments2 = Enum.zip(wire2, Enum.drop(wire2, 1))

    for s1 <- segments1, s2 <- segments2, do: intersection(s1, s2)
  end

  def intersection({{x1, y}, {x2, y}}, {{x, y3}, {x, y4}}) do
    {x1, x2} = if x1 < x2, do: {x1, x2}, else: {x2, x1}
    {y3, y4} = if y3 < y4, do: {y3, y4}, else: {y4, y3}

    if x1 <= x && x <= x2 && y3 <= y && y <= y4, do: {x, y}, else: nil
  end
  def intersection({{x, y1}, {x, y2}}, {{x3, y}, {x4, y}}) do
    {y1, y2} = if y1 < y2, do: {y1, y2}, else: {y2, y1}
    {x3, x4} = if x3 < x4, do: {x3, x4}, else: {x4, x3}

    if y1 <= y && y <= y2 && x3 <= x && x <= x4, do: {x, y}, else: nil
  end
  def intersection(_, _), do: nil
end

ExUnit.start()

defmodule Part1Test do
  use ExUnit.Case

  describe "path_to_coordinates/1" do
    test "a path with all directions" do
      path = ~w(R75 D30 R83 U83 L12 D49 R71 U7 L72)
      assert Part1.path_to_coordinates(path) ==
        [{0, 0}, {75,0}, {75, -30}, {158, -30}, {158, 53}, {146, 53}, {146, 4}, {217, 4}, {217, 11}, {145, 11}]
    end
  end

  describe "taxicab_distance/2" do
    test "between two random points" do
      assert Part1.taxicab_distance({5, 4}, {9, 3}) == 5
    end
  end

  describe "intersection/2" do
    test "between an horizontal and vertical segment crossing each other" do
      segment1 = {{-1, 3}, {7, 3}}
      segment2 = {{2, 4}, {2, 0}}

      assert Part1.intersection(segment1, segment2) == {2, 3}
    end

    test "between a vertical and an horizontal segment crossing each other" do
      segment1 = {{2, 4}, {2, 0}}
      segment2 = {{-1, 3}, {7, 3}}

      assert Part1.intersection(segment1, segment2) == {2, 3}
    end

    test "between two vertical segments" do
      segment1 = {{2, 4}, {2, 0}}
      segment2 = {{4, 1}, {4, 4}}

      assert Part1.intersection(segment1, segment2) == nil
    end

    test "between two horizontal segments" do
      segment1 = {{-1, 3}, {7, 3}}
      segment2 = {{1, 1}, {5, 1}}

      assert Part1.intersection(segment1, segment2) == nil
    end

    test "general test" do
      segment1 = {{0, 0}, {0, 3}}
      segment2 = {{0, 0}, {1, 0}}

      assert Part1.intersection(segment1, segment2) == {0, 0}

      segment1 = {{0, 3}, {1, 3}}
      segment2 = {{1, 0}, {1, 2}}

      assert Part1.intersection(segment1, segment2) == nil
    end
  end

  test "closest_intersection/2" do
    wire1 = ~w(R75 D30 R83 U83 L12 D49 R71 U7 L72)
    wire2 = ~w(U62 R66 U55 R34 D71 R55 D58 R83)

    assert Part1.closest_intersection(wire1, wire2) == 159
  end

  test "closest_intersection/2 with small numbers" do
    wire1 = ~w(U3 R1 D1 R1 D1)
    wire2 = ~w(R1 U2 L1)

    assert Part1.closest_intersection(wire1, wire2) == 2
  end
end

input =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ","))

[wire1, wire2] = input
Part1.closest_intersection(wire1, wire2) |> IO.inspect(label: "Part1")
