defmodule Diagnostic do

  # Improved version based on Jose Valim's code: https://www.twitch.tv/videos/1223929784
  def gamma(binaries, bin_length) do
    digits = Enum.map(binaries, &String.to_charlist/1)
    half = div(length(digits), 2)

    gammas =
      for pos <- 0..bin_length - 1 do
        zeroes = Enum.count_until(digits, &(Enum.at(&1, pos) == ?0), half + 1)
        if zeroes > half, do: ?0, else: ?1
      end

    List.to_integer(gammas, 2)
  end
end

binaries =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

bin_length =
  binaries
  |> List.first()
  |> String.length()

gamma = Diagnostic.gamma(binaries, bin_length)
epsilon = (2 ** bin_length - 1) - gamma
IO.inspect(gamma * epsilon, label: "Part 1")
