defmodule Day8 do
  def update_registers(%{"amount" => amount, "register" => reg} = action, {registers, maximum}) do
    registers = if condition_met?(registers, action), do: Map.update(registers, reg, amount, &(&1 + amount)), else: registers

    {registers, max(maximum, Map.values(registers) |> Enum.max(fn -> 0 end))}
  end

  def inverse_decrement_operation(%{"operation" => "dec", "amount" => amount} = action) do
    %{action | "operation" => "inc", "amount" => -amount}
  end

  def inverse_decrement_operation(action), do: action

  def remove_operation(action), do: Map.delete(action, "operation")

  defp condition_met?(registers, %{"subject" => subj, "test" => test, "value" => val}) do
    apply(Kernel, test, [Map.get(registers, subj, 0), val])
  end

  def to_integer(action) do
    action
    |> Map.update!("amount", &String.to_integer/1)
    |> Map.update!("value", &String.to_integer/1)
  end
end

line_scan = ~r/(?<register>.*) (?<operation>inc|dec) (?<amount>-?\d+) if (?<subject>.*) (?<test><|>|<=|>=|==|!=) (?<value>-?\d+)/

{registers, maximum} =
  "input.txt"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Stream.map(&Regex.named_captures(line_scan, &1))
  |> Stream.map(&Day8.to_integer/1)
  |> Stream.map(&Day8.inverse_decrement_operation/1)
  |> Stream.map(&Day8.remove_operation/1)
  |> Enum.reduce({%{}, 0}, &Day8.update_registers/2)

IO.inspect(registers |> Map.values |> Enum.max, label: "Highest value in registers")
IO.inspect(maximum, label: "Highest values at all time")
