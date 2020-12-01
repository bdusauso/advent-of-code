sorted_elems =
  "input.txt"
  |> File.read!()
  |> String.split()
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

tuples = for i <- sorted_elems,
               j <- sorted_elems,
               i + j == 2020,
               do: {{i, j}, i * j}

IO.inspect(List.first(tuples), label: "Part 1")
