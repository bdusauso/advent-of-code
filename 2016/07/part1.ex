defmodule AoC.Abba do

  def count_tls(input) do
    input
    |> Enum.filter(&support_tls/1)
    |> length
  end

  def support_tls(ip_address) do
    [outside, inside] = partition(ip_address)
    (outside |> Enum.any?(&abba/1)) && !(inside |> Enum.any?(&abba/1))
  end

  defp abba(ip_chunk) do
    case ~r/(.)(.)(\2\1)/ |> Regex.run(ip_chunk) do
      [_, a, b, _] -> a != b
      _            -> false
    end
  end

  defp partition(ip_address) do
    ip_address
    |> String.replace(~r/(\[|\])/, ",")
    |> String.split(",")
    |> Enum.with_index
    |> Enum.partition(fn {_, idx} -> rem(idx, 2) == 0 end)
    |> Tuple.to_list
    |> Enum.map(&(Enum.map(&1, fn e -> elem(e, 0) end)))
  end

end
