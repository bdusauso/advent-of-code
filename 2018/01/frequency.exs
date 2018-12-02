defmodule Frequency do
  
  def apply_changes(frequencies) do
    frequencies |> Enum.sum
  end

  def find_repetition(frequencies) do
    frequencies
    |> Stream.cycle
    |> Enum.reduce_while([0], fn frequency, partial_sums ->
        current_sum = List.first(partial_sums) + frequency 
        new_partial_sums = [current_sum | partial_sums]
        status = if Enum.member?(partial_sums, current_sum), do: :halt, else: :cont
        
        {status, new_partial_sums}
    end)
    |> List.first
  end
end

frequencies = 
  "input.txt"
  |> File.stream!([])
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)

IO.puts(Frequency.apply_changes(frequencies))
IO.puts(Frequency.find_repetition(frequencies))