defmodule AoC.Room do

  def sector_ids_sum(names) do
    names
    |> Enum.filter(&real/1)
    |> Enum.reduce(0, &(&2 + (AoC.Room.sector_id(&1) |> String.to_integer)))
  end

  def real(name) do
    calculate_checksum(name) == extract_checksum(name)
  end

  def sector_id(name), do: ~r/([0-9]{1,})/ |> first_match(name)

  def extract_checksum(name), do: ~r/\[([a-z]{1,})\]$/ |> first_match(name)

  def calculate_checksum(name) do
    name
    |> normalize_name
    |> count_letter_occurences
    |> extract_highest_occurrences_letters
    |> concatenate_highest_occurences_letters
  end

  defp count_letter_occurences(name) do
    name
    |> String.codepoints
    |> Enum.reduce(%{},
      fn letter, occurences ->
        occurences
        |> Map.update(letter, 1, &(&1+ 1))
      end)
  end

  defp extract_highest_occurrences_letters(occurences) do
    occurences
    |> Enum.to_list
    |> Enum.sort_by(fn {_, count} -> count end, &>=/2)
    |> Enum.take(5)
  end

  defp concatenate_highest_occurences_letters(occurences) do
    occurences
    |> Enum.reduce("", &(&2 <> elem(&1, 0)))
  end

  defp normalize_name(name) do
    name
    |> String.split("-")
    |> Enum.drop(-1)
    |> Enum.join
  end

  defp first_match(regex, str) do
    regex
    |> Regex.run(str)
    |> Enum.take(-1)
    |> Enum.fetch!(0)
  end
end
