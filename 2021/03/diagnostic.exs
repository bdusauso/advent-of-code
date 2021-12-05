defmodule Diagnostic do

  # Improved version based on Jose Valim's code: https://www.twitch.tv/videos/1223929784
  def gamma(binaries, bin_length) do
    digits = Enum.map(binaries, &String.to_charlist/1)
    gammas = for pos <- 0..bin_length - 1, do: most_common_bit(digits, pos)

    List.to_integer(gammas, 2)
  end

  def oxygen_ratings(binaries) do
    binaries
    |> Enum.map(&String.to_charlist/1)
    |> rating(0, :most)
  end

  def co2_ratings(binaries) do
    binaries
    |> Enum.map(&String.to_charlist/1)
    |> rating(0, :least)
  end

  defp rating([digits], _pos, _commonality), do: List.to_integer(digits, 2)
  defp rating(digits_list, pos, commonality) do
    bit = most_common_bit(digits_list, pos)
    bit =
      case commonality do
        :most -> bit
        :least -> if bit == ?1, do: ?0, else: ?1
      end

    rating(Enum.filter(digits_list, &(Enum.at(&1, pos) == bit)), pos + 1, commonality)
  end

  defp most_common_bit(binaries_charlist, position) do
    half = div(length(binaries_charlist), 2)
    zeroes = Enum.count_until(binaries_charlist, &(Enum.at(&1, position) == ?0), half + 1)

    if zeroes > half, do: ?0, else: ?1
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

oxygen = Diagnostic.oxygen_ratings(binaries)
co2 = Diagnostic.co2_ratings(binaries)
IO.inspect(oxygen * co2, label: "Part 2")
