defmodule Day8 do
  def update_registers(%{"amount" => amount, "register" => reg} = action, registers) do
    IO.inspect(registers, label: "Registers")
    if condition_met?(registers, action), do: Map.update(registers, reg, amount, &(&1 + amount)), else: registers
  end

  def inverse_decrement_operation(%{"operation" => "dec", "amount" => amount} = action) do
    %{action | "operation" => "inc", "amount" => -amount}
  end

  def inverse_decrement_operation(action), do: action

  def remove_operation(action), do: Map.delete(action, "operation")

  defp condition_met?(registers, %{"subject" => subj, "test" => test, "value" => val}) do
    to_compare = Map.get(registers, subj, 0)
    case test do
      "<"  -> to_compare < val
      ">"  -> to_compare > val
      "<=" -> to_compare <= val
      ">=" -> to_compare >= val
      "==" -> to_compare == val
      "!=" -> to_compare != val
    end
  end

  def to_integer(%{"amount" => amount, "value" => val} = action) do
    action
    |> Map.update!("amount", &String.to_integer/1)
    |> Map.update!("value", &String.to_integer/1)
  end
end

line_scan = ~r/(?<register>.*) (?<operation>inc|dec) (?<amount>-?\d+) if (?<subject>.*) (?<test><|>|<=|>=|==|!=) (?<value>-?\d+)/

input =
  "input.txt"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Stream.map(&Regex.named_captures(line_scan, &1))
  |> Stream.map(&Day8.to_integer/1)
  |> Stream.map(&Day8.inverse_decrement_operation/1)
  |> Stream.map(&Day8.remove_operation/1)
  |> Enum.reduce(%{}, &Day8.update_registers/2)
  |> IO.inspect(label: "Registers")
  |> Map.values
  |> Enum.max

IO.inspect(input, label: "Highest value in registers")
