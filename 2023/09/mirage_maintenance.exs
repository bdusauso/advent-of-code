defmodule MirageMaintenance do
  def next_value(history, backward) do
    case Enum.all?(history, &(&1 == 0)) do
      true ->
        0

      false ->
        next_value = history |> differences() |> next_value(backward)

        if backward,
          do: List.first(history) - next_value,
          else: List.last(history) + next_value
    end
  end

  def differences(list), do: differences(list, [])

  defp differences([_], acc), do: Enum.reverse(acc)
  defp differences([a, b | rest], acc), do: differences([b | rest], [b - a | acc])
end

input =
  "input.txt"
  |> File.stream!()
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(&Enum.map(&1, fn e -> String.to_integer(e) end))

input
|> Enum.map(&MirageMaintenance.next_value(&1, false))
|> Enum.sum()
|> IO.inspect(label: "Part 1")

input
|> Enum.map(&MirageMaintenance.next_value(&1, true))
|> Enum.sum()
|> IO.inspect(label: "Part 2")
