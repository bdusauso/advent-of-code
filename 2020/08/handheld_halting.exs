defmodule Handheld do
  def disassemble(<<instr::bytes-size(3)>> <> " " <> arg), do: {instr, String.to_integer(arg)}

  def detect_loop(operations), do: detect_loop(operations, 0, 0, [])

  defp detect_loop(operations, cur_idx, sum, checked) do
    if cur_idx in checked do
      sum
    else
      checked = [cur_idx | checked]
      case Enum.at(operations, cur_idx) do
        {"acc", amount} ->
          detect_loop(operations, cur_idx + 1, sum + amount, checked)

        {"nop", _} ->
          detect_loop(operations, cur_idx + 1, sum, checked)

        {"jmp", amount} ->
          detect_loop(operations, cur_idx + amount, sum, checked)
      end
    end
  end
end

operations =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&Handheld.disassemble/1)

operations
|> Handheld.detect_loop()
|> IO.inspect(label: "Part 1")
