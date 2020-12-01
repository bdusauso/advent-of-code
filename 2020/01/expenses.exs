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

tuples = for i <- sorted_elems,
               j <- sorted_elems,
               k <- sorted_elems,
               i + j + k == 2020,
               do: {{i, j, k}, i * j * k}

IO.inspect(List.first(tuples), label: "Part 2")
