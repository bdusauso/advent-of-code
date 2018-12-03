defmodule Grid do

  defstruct content: %{}, size: 0

  def new(size), do: %Grid{content: %{}, size: size}

  def overlapping_count(coordinates, grid_size) do
    grid = Enum.reduce(coordinates, new(grid_size), &claim/2)
    grid.content |> Map.values |> Enum.filter(&(&1 >= 2)) |> length
  end

  def claim([id, left, top, width, height], %Grid{} = grid) do
    IO.puts("Processing id ##{id}")
    to_check = for i <- 0..(height - 1), j <- 0..(width - 1), do: {top + i, left + j}
    Enum.reduce(to_check, grid, fn i, acc -> 
      %Grid{acc | content: Map.update(acc.content, i, 1, &(&1 + 1))} 
    end)
  end
end

ExUnit.start

defmodule GridTest do
  use ExUnit.Case

  describe ".claim/1" do
    grid = Grid.new(5)
    grid = Grid.claim([0, 3, 2, 2, 2], grid)
    
    assert grid.content == %{{2, 3} => 1, {2, 4} => 1, {3, 3} => 1, {3, 4} => 1}
  end
end

"input.txt"
|> File.stream!([])
|> Enum.map(&(Regex.scan(~r/-?\d+/, &1)))
|> Enum.map(fn line -> line |>  List.flatten |> Enum.map(&String.to_integer/1) end)
|> Grid.overlapping_count(1000)
|> IO.inspect
