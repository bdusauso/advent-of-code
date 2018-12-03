defmodule Grid do

  defstruct content: [], size: 0

  def new(size), do: %Grid{content: List.duplicate(0, size * size), size: size}

  def overlapping_count(coordinates, grid_size) do
    grid = Enum.reduce(coordinates, new(grid_size), &claim/2)
    grid.content |> Enum.filter(&(&1 >= 2)) |> length
  end

  def claim([id, left, top, width, height], %Grid{} = grid) do
    # IO.puts "Processing id ##{id}"
    to_check = for i <- 0..(height - 1), j <- 0..(width - 1), do: ((top + i) * grid.size) + left + j
    IO.inspect(to_check)
    Enum.reduce(to_check, grid, fn i, acc -> %Grid{acc | content: List.update_at(acc.content, i, &(&1 + 1))} end)
  end
end

ExUnit.start

defmodule GridTest do
  use ExUnit.Case

  describe ".claim/1" do
    grid = Grid.new(5)
    grid = Grid.claim([0, 3, 2, 2, 2], grid)
    
    assert grid.content == [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1],
      [0, 0, 0, 1, 1],
      [0, 0, 0, 0, 0]
    ] |> List.flatten
  end
end

"input.txt"
|> File.stream!([])
|> Enum.map(&(Regex.scan(~r/-?\d+/, &1)))
|> Enum.map(fn line -> line |>  List.flatten |> Enum.map(&String.to_integer/1) end)
|> Grid.overlapping_count(1000)
|> IO.inspect
