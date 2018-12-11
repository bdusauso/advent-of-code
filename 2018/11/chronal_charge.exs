defmodule ChronalCharge do
  @grid_size 300

  def biggest_largest_total_power(serial_number) do
    Enum.map(1..@grid_size, fn size -> 
      {x, y, power} = max_square_coordinates(serial_number, size)
      {x, y, power, size} |> IO.inspect
    end)
  end

  def max_square_coordinates(serial_number, square_size \\ 3) do
    total_powers = for x <- 1..(@grid_size - square_size), 
                       y <- 1..(@grid_size - square_size), 
                       do: {x, y, square(x, y, serial_number, square_size)}

    total_powers 
    |> Enum.map(fn {x, y, total_power} -> {x, y, Enum.sum(total_power)} end)
    |> Enum.max_by(fn {_, _, total_power} -> total_power end)
  end

  def power_level(x, y, serial_number) do
    rack_id = x + 10
    div(rem((rack_id * y + serial_number) * rack_id, 1000), 100) - 5 
  end

  def square(x, y, serial_number, square_size \\ 3) do
    for a <- x..x+square_size-1, b <- y..y+square_size-1, do: power_level(a, b, serial_number)
  end
end

ExUnit.start

defmodule ChronalChargeTest do
  use ExUnit.Case

  describe "power_level/3" do
    data = [
      [3, 5, 8], 
      [122, 79, 57],
      [217, 196, 39],
      [101, 153, 71]
    ]

    assert data |> Enum.map(&(apply(ChronalCharge, :power_level, &1))) == [4, -5, 0, 4]
  end
end

# ChronalCharge.max_square_coordinates(7803, 3)
# ChronalCharge.biggest_largest_total_power(7803)