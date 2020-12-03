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

# Generalization of traversal.
# Part 1 is a special case but could be computed using this function
traversal = fn {right, down} ->
  input
  |> Enum.take_every(down)
  |> Enum.with_index()
  |> Enum.count(fn {line, num} -> String.at(line, rem(num * right, length)) == "#" end)
end

[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
|> Enum.reduce(1, fn trees, product -> traversal.(trees) * product end)
|> IO.inspect(label: "Part 2")
