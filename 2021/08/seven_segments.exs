input = File.read!("input.txt")

lines =
  input
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " | ", trim: true))

entries =
  lines
  |> Enum.map(&List.first/1)
  |> Enum.map(&String.split(&1, " ", trim: true))

outputs =
  lines
  |> Enum.map(&Enum.at(&1, 1))
  |> Enum.map(&String.split(&1, " ", trim: true))

input = Enum.zip(entries, outputs)

outputs
|> Enum.map(&Enum.count(&1, fn digit -> String.length(digit) in [2, 3, 4, 7] end))
|> Enum.sum()
|> IO.inspect(label: "Part 1")
