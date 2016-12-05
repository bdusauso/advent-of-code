defmodule AoC.Password do

  def guess(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&(:erlang.md5("#{input}#{&1}")) |> Base.encode16(case: :lower))
    |> Stream.filter(&(String.starts_with?(&1, "00000")))
    |> Stream.map(&(String.at(&1, 5)))
    |> Stream.take(8)
    |> Enum.join
  end

end
