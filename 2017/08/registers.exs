defmodule Day8 do
  @line_scan ~r/(?<register>.*) (?<operation>inc|dec) (?<amount>-?\d+) if (?<subject>.*) (?<test><|>|<=|>=|==|!=) (?<value>-?\d+)/

  def run(lines) do
    lines
    |> Stream.map(&Regex.named_captures(@line_scan, &1))
    |> Stream.map(&normalize/1)
    |> Stream.map(&inverse_decrement_operation/1)
    |> Stream.map(&remove_operation/1)
    |> Enum.reduce({%{}, 0}, &update_registers/2)
  end

  defp update_registers(%{"amount" => amount, "register" => reg} = action, {registers, maximum}) do
    registers = if condition_met?(registers, action), do: Map.update(registers, reg, amount, &(&1 + amount)), else: registers

    {registers, max(maximum, Map.values(registers) |> Enum.max(fn -> 0 end))}
  end

  defp inverse_decrement_operation(%{"operation" => "dec", "amount" => amount} = action) do
    %{action | "operation" => "inc", "amount" => -amount}
  end

  defp inverse_decrement_operation(action), do: action

  defp remove_operation(action), do: Map.delete(action, "operation")

  defp condition_met?(registers, %{"subject" => subj, "test" => test, "value" => val}) do
    apply(Kernel, test, [Map.get(registers, subj, 0), val])
  end

  defp normalize(action) do
    action
    |> Map.update!("amount", &String.to_integer/1)
    |> Map.update!("value", &String.to_integer/1)
    |> Map.update!("test", &String.to_atom/1)
  end
end

{registers, maximum} =
  "input.txt"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Day8.run

IO.inspect(registers |> Map.values |> Enum.max, label: "Highest value in registers")
IO.inspect(maximum, label: "Highest values at all time")
