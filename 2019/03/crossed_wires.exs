defmodule Part1 do
  def closest_intersection(wire1, wire2) do
    wire1
    |> intersections(wire2)
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

    res = for s1 <- segments1, s2 <- segments2, do: intersection(s1, s2)
    res
    |> Enum.reject(&is_nil/1)
    |> Enum.reject(&(&1 == {0, 0}))
  end

  def intersection({{x1, y}, {x2, y}}, {{x, y3}, {x, y4}}) do
    {x1, x2} = sort(x1, x2)
    {y3, y4} = sort(y3, y4)

    if between?(x, x1, x2) && between?(y, y3, y4), do: {x, y}, else: nil
  end
  def intersection({{x, y1}, {x, y2}}, {{x3, y}, {x4, y}}) do
    {y1, y2} = sort(y1, y2)
    {x3, x4} = sort(x3, x4)

    if between?(y, y1, y2) && between?(x, x3, x4), do: {x, y}, else: nil
  end
  def intersection(_, _), do: nil

  defp sort(a, b), do: if a < b, do: {a, b}, else: {b, a}
  defp between?(x, a, b), do: a <= x && x <= b
end

defmodule Part2 do
  import Part1

  def best_steps(wire1, wire2) do
    wire1
    |> intersections(wire2)
    |> Enum.map(&(steps_to_intersection(wire1, &1) + steps_to_intersection(wire2, &1)))
    |> Enum.sort()
    |> List.first()
  end

  def steps_to_intersection(wire, crossing) do
    wire
    |> steps()
    |> Enum.find_index(&(&1 == crossing))
  end

  def steps(wire) do
    wire = path_to_coordinates(wire)

    wire
    |> Enum.zip(Enum.drop(wire, 1))
    |> Enum.reduce([], fn {from, to}, acc -> [from |> steps_to(to) |> Enum.reverse() | acc] end)
    |> List.flatten()
    |> Enum.reverse()
  end

  def steps_to({x, y1}, {x, y2}) when y1 > y2, do: (for y <- 1..abs(y1 - y2), do: {x, y1 - y})
  def steps_to({x, y1}, {x, y2}) when y1 < y2, do: (for y <- 1..abs(y1 - y2), do: {x, y1 + y})
  def steps_to({x1, y}, {x2, y}) when x1 > x2, do: (for x <- 1..abs(x1 - x2), do: {x1 - x, y})
  def steps_to({x1, y}, {x2, y}) when x1 < x2, do: (for x <- 1..abs(x1 - x2), do: {x1 + x, y})
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

defmodule Part2Test do
  use ExUnit.Case
  import Part2

  describe "steps_to/2" do
    test "when we go up" do
      assert steps_to({-1, -2}, {-1, 3}) == [{-1, -1}, {-1, 0}, {-1, 1}, {-1, 2}, {-1, 3}]
    end

    test "when we go down" do
      assert steps_to({-1, -2}, {-1, -4}) == [{-1, -3}, {-1, -4}]
    end

    test "when we go left" do
      assert steps_to({-1, -2}, {-3, -2}) == [{-2, -2}, {-3, -2}]
    end

    test "when we go right" do
      assert steps_to({-1, -2}, {2, -2}) == [{0, -2}, {1, -2}, {2, -2}]
    end
  end

  describe "steps/1" do
    test "small numbers" do
      wire = ~w(U3 R1 D1 R1 D1)
      assert steps(wire) == [{0, 1}, {0, 2}, {0, 3}, {1, 3}, {1, 2}, {2, 2}, {2, 1}]
    end
  end

  describe "best_steps/1" do
    test "first example" do
      wire1 = ~w(R75 D30 R83 U83 L12 D49 R71 U7 L72)
      wire2 = ~w(U62 R66 U55 R34 D71 R55 D58 R83)

      assert Part2.best_steps(wire1, wire2) + 2 == 610
    end
  end
end

input =
  "input.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ","))

[wire1, wire2] = input
Part1.closest_intersection(wire1, wire2) |> IO.inspect(label: "Part1")
Part2.best_steps(wire1, wire2) |> IO.inspect(label: "Part2")
