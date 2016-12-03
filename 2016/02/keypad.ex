defmodule AoC.Keypad do

  @start_key_idx 4

  @vertical_move    3
  @horizontal_move  1

  def secret_code(input_lines) do
    input_lines
    |> Enum.reduce([@start_key_idx], &([next_key(&1, hd(&2)) | &2]))
    |> Enum.reverse
    |> Enum.drop(1)
    |> Enum.map(&(&1 + 1))
  end

  defp next_key(input_line, start_key) do
    input_line
    |> String.codepoints
    |> Enum.reduce(start_key, fn movement, start_index -> move(movement, start_index) end)
  end

  defp move("U", key_index) when key_index <= 2, do: key_index
  defp move("U", key_index), do: key_index - @vertical_move

  defp move("D", key_index) when key_index >= 7, do: key_index
  defp move("D", key_index), do: key_index + @vertical_move

  defp move("L", key_index) when rem(key_index, 3) == 0, do: key_index
  defp move("L", key_index), do: key_index - @horizontal_move

  defp move("R", key_index) when rem(key_index, 3) == 2, do: key_index
  defp move("R", key_index), do: key_index + @horizontal_move
end
