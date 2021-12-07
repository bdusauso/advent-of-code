input =
  "input.txt"
  |> File.read!()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

{min, max} = Enum.min_max(input)

lowest_fuel_consumption = fn consumption_func ->
  total_consumptions =
    for pos <- min..max do
      input
      |> Enum.map(&consumption_func.(&1, pos))
      |> Enum.sum()
    end

  Enum.min(total_consumptions)
end

consumption1 = fn position, destination ->
  abs(position - destination)
end

IO.inspect(lowest_fuel_consumption.(consumption1), label: "Part 1")

consumption2 = fn position, destination ->
  distance = abs(position - destination)
  div(distance * (distance + 1), 2)
end

IO.inspect(lowest_fuel_consumption.(consumption2), label: "Part 2")
