defmodule Handheld do
  def disassemble(<<instr::bytes-size(3)>> <> " " <> arg), do: {instr, String.to_integer(arg)}

  def find_termination(operations) do
    try do
      for idx <- 0..length(operations) - 1 do
        case operations |> Handheld.swap_instruction(idx) |> Handheld.detect_loop() do
          {:termination, sum} -> throw({:ok, sum})
          res -> res
        end
      end
    catch
      {:ok, sum} -> sum
    end
  end

  def swap_instruction(operations, idx) do
    new_operation =
      case Enum.at(operations, idx) do
        {"nop", amount} -> {"jmp", amount}
        {"jmp", amount} -> {"nop", amount}
        operation -> operation
      end

    List.replace_at(operations, idx, new_operation)
  end

  def detect_loop(operations), do: detect_loop(operations, 0, 0, [])

  defp detect_loop(operations, cur_idx, sum, checked) do
    cond do
      cur_idx in checked ->
        {:loop, sum}

      cur_idx not in 0..length(operations) - 1 ->
        {:termination, sum}

      true ->
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
|> elem(1)
|> IO.inspect(label: "Part 1")

operations
|> Handheld.find_termination()
|> IO.inspect(label: "Part 2")
