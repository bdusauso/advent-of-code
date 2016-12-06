defmodule AoC.NoiseSignal do

  def remove_noise(signal) do
    for i <- 0..7 do
      signal
      |> Enum.map(&(String.at(&1, i)))
      |> count_letter_occurences
      |> extract_highest_occurrences_letters
    end |> Enum.join
  end

  defp count_letter_occurences(signal) do
    signal
    |> Enum.reduce(%{},
      fn letter, occurences ->
        occurences
        |> Map.update(letter, 1, &(&1+ 1))
      end)
  end

  defp extract_highest_occurrences_letters(occurences) do
    occurences
    |> Enum.to_list
    |> Enum.min_by(fn {_, x} -> x end)
    |> elem(0)
  end

end
