defmodule Grid do

  def intact_claim(inputs) do
    grid = Enum.reduce(inputs, %{}, &(claim(&2, &1)))
    
    Enum.reduce_while(inputs, nil, fn [input_id | measurements], acc ->
      coordinates = calculate_coordinates(measurements)
      if Enum.all?(coordinates, fn coordinate -> Map.fetch!(grid, coordinate) == {input_id, 1} end) do
        {:halt, input_id}
      else
        {:cont, nil}
      end
    end)
  end

  def overlapping_count(inputs) do
    inputs
    |> Enum.reduce(%{}, &(claim(&2, &1)))
    |> Map.values 
    |> Enum.filter(fn {_id, count} -> count >= 2 end) 
    |> length
  end

  def claim(grid, [id | measurements]) do
    # IO.puts("Processing id ##{id}")
    measurements
    |> calculate_coordinates
    |> Enum.reduce(grid, fn i, acc -> 
        Map.update(acc, i, {id, 1}, fn {id, count} -> {id, count + 1} end) 
      end)
  end

  def calculate_coordinates([left, top, width, height]) do
    for i <- 0..(height - 1), j <- 0..(width - 1), do: {top + i, left + j}
  end
end

ExUnit.start

defmodule GridTest do
  use ExUnit.Case

  describe ".claim/1" do
    assert Grid.claim(%{}, [0, 3, 2, 2, 2]) == %{
      {2, 3} => {0, 1}, 
      {2, 4} => {0, 1}, 
      {3, 3} => {0, 1}, 
      {3, 4} => {0, 1}
    }
  end
end

inputs =
  "input.txt"
  |> File.stream!([])
  |> Enum.map(&(Regex.scan(~r/-?\d+/, &1)))
  |> Enum.map(fn line -> line |>  List.flatten |> Enum.map(&String.to_integer/1) end)

inputs
  |> Grid.overlapping_count
  |> IO.inspect(label: "Overlapping claims count")

inputs
  |> Grid.intact_claim
  |> IO.inspect(label: "Only intact claim id")
