
defmodule OldPolicy do
  def valid?(%{"password" => password, "char" => char, "min" => min, "max" => max}) do
    valid?(password, char, String.to_integer(min), String.to_integer(max))
  end
  def valid?(password, char, min, max) do
    occurrences =
      password
      |> String.graphemes()
      |> Enum.count(&(&1 == char))

    occurrences in (min..max)
  end
end

defmodule NewPolicy do
  def valid?(%{"password" => password, "char" => char, "min" => min, "max" => max}) do
    valid?(password, char, String.to_integer(min), String.to_integer(max))
  end
  def valid?(password, char, min, max) do
    (String.at(password, min - 1) == char) != (String.at(password, max - 1) == char)
  end
end

regex = ~r/(?<min>\d+)-(?<max>\d+) (?<char>[a-z]): (?<password>[a-z]+)/

inputs =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&Regex.named_captures(regex, &1))

inputs
|> Enum.count(&OldPolicy.valid?/1)
|> IO.inspect(label: "Part 1")

inputs
|> Enum.count(&NewPolicy.valid?/1)
|> IO.inspect(label: "Part 2")
