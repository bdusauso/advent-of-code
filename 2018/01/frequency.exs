defmodule Frequency do
  
  def apply_changes(frequencies) do
    frequencies 
    |> Enum.reduce(0, fn frequency, sum -> apply_change(sum, frequency) end)
  end

  def find_repetition(frequencies) do
    frequencies
    |> Stream.cycle
    |> Enum.reduce_while([0], fn frequency, partial_sums ->
        current_sum = partial_sums |> List.first |> apply_change(frequency) 
        new_partial_sums = [current_sum | partial_sums]
        
        if Enum.member?(partial_sums, current_sum), do: {:halt, new_partial_sums}, else: {:cont, new_partial_sums}
    end)
    |> List.first
  end

  defp apply_change(start, "-" <> frequency), do: start - (String.to_integer(frequency))  
  defp apply_change(start, "+" <> frequency), do: start + (String.to_integer(frequency))  
end

frequencies = 
  "input.txt"
  |> File.read!
  |> String.split("\n")

IO.puts(Frequency.apply_changes(frequencies))
IO.puts(Frequency.find_repetition(frequencies))