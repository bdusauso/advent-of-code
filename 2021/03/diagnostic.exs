defmodule Diagnostic do

  def gamma(binaries) do
    binaries
    |> Enum.map(&String.graphemes/1)
    |> transpose()
    |> Enum.reduce([], fn line, acc -> if Enum.count(line, &(&1 == "1")) > Enum.count(line, &(&1 == "0")), do: [1 | acc], else: [0 | acc] end)
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
  end

  # Taken from https://gist.github.com/pmarreck/6e054c162844e9d83d89
  defp transpose([[x | xs] | xss]) do
    [[x | (for [h | _] <- xss, do: h)] | transpose([xs | (for [_ | t] <- xss, do: t)])]
  end
  defp transpose([[] | xss]), do: transpose(xss)
  defp transpose([]), do: []
end

binaries =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

gamma = Diagnostic.gamma(binaries)
epsilon = 4095 - gamma
IO.inspect(gamma * epsilon, label: "Part 1")
