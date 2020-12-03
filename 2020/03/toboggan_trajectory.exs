input =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

# Avoid computing it each time
length =
  input
  |> List.first()
  |> String.length()

input
|> Enum.with_index()
|> Enum.count(fn {line, num} -> String.at(line, rem(num * 3, length)) == "#" end)
|> IO.inspect(label: "Part 1")
