defmodule Part1 do
  def run(intcode), do: run(intcode, 0)

  defp run(intcode, pos) do
    case evaluate_opcode(intcode, pos, Enum.at(intcode, pos))do
      {:cont, intcode} ->
        run(intcode, pos + 4)

      {:halt, intcode} ->
        intcode
    end
  end

  defp evaluate_opcode(intcode, current_pos, 1) do
    {op1, op2, dst} = operands(intcode, current_pos)
    {:cont, List.replace_at(intcode, dst, op1 + op2)}
  end
  defp evaluate_opcode(intcode, current_pos, 2) do
    {op1, op2, dst} = operands(intcode, current_pos)
    {:cont, List.replace_at(intcode, dst, op1 * op2)}
  end
  defp evaluate_opcode(intcode, _, 99), do: {:halt, intcode}

  defp operands(intcode, current_pos) do
    op1 = Enum.at(intcode, Enum.at(intcode, current_pos + 1))
    op2 = Enum.at(intcode, Enum.at(intcode, current_pos + 2))
    dst = Enum.at(intcode, current_pos + 3)

    {op1, op2, dst}
  end
end

ExUnit.start()

defmodule Part1Test do
  use ExUnit.Case

  test "run/1" do
    assert Part1.run([1,0,0,0,99]) == [2, 0, 0, 0, 99]
    assert Part1.run([2,3,0,3,99]) == [2, 3, 0, 6, 99]
    assert Part1.run([2,4,4,5,99,0]) == [2, 4, 4, 5, 99, 9801]
    assert Part1.run([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end
end

input =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> IO.inspect()

input
|> Part1.run()
|> Enum.at(0)
|> IO.inspect(label: "Answer")
