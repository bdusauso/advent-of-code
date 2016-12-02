defmodule AoC.Keypad do

  @center_idx 4

  @vertical_move    3
  @horizontal_move  1

  def unlock(input_lines) do
  end

  defp next_key(input_line, start_key), do:

  defp move("U", key_index), do: key_index - vertical_move
  defp move("D", key_index), do: key_index + vertical_move
  defp move("L", key_index), do: key_index - horizontal_move
  defp move("R", key_index), do: key_index + horizontal_move
end
