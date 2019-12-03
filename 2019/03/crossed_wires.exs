defmodule Part1 do
  def path_to_coordinates(path) do
    Enum.map(path, &step_to_displacement/1)
  end

  def step_to_displacement("R" <> dist), do: {String.to_integer(dist), 0}
  def step_to_displacement("L" <> dist), do: {-String.to_integer(dist), 0}
  def step_to_displacement("U" <> dist), do: {0, String.to_integer(dist)}
  def step_to_displacement("D" <> dist), do: {0, -String.to_integer(dist)}
end

ExUnit.start()

defmodule Part1Test do
  use ExUnit.Case

  test "path_to_coordinates/1" do
    path = ~w(R75 D30 R83 U83 L12 D49 R71 U7 L72)
    assert Part1.path_to_coordinates(path) ==
      [{75, 0}, {0, -30}, {83, 0}, {0, 83}, {-12, 0}, {0, -49}, {71, 0}, {0, 7}, {-72, 0}]
  end
end
