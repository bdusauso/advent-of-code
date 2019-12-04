defmodule Part1 do
  def count_passwords(from, to) do
    Enum.count(from..to, &candidate?(&1, from, to))
  end

  def candidate?(number, from, to) when number in from..to do
    number_list = number_to_list(number)
    one_double?(number_list) && increase?(number_list)
  end
  def candidate?(_, _, _), do: false

  def one_double?([a, a, _, _, _, _]), do: true
  def one_double?([_, b, b, _, _, _]), do: true
  def one_double?([_, _, c, c, _, _]), do: true
  def one_double?([_, _, _, d, d, _]), do: true
  def one_double?([_, _, _, _, e, e]), do: true
  def one_double?(_), do: false

  def increase?([a, b, c, d, e, f]) when a <= b and b <= c and c <= d  and d <= e  and e <= f, do: true
  def increase?(_), do: false

  def number_to_list(number), do: number_to_list(number, [])
  def number_to_list(number, acc) when rem(number, 10) == 0, do: acc
  def number_to_list(number, acc), do: number_to_list(div(number, 10), [rem(number, 10) | acc])
end

ExUnit.start()

defmodule Part1Test do
  use ExUnit.Case
  import Part1

  describe "candidate?/3" do
    test "six-digits, within range, ascending order, one double" do
      assert candidate?(246678, 246515, 739105)
    end
  end

  describe "number_to_list/1" do
    test "one digit" do
      assert number_to_list(2) == [2]
      assert number_to_list(24) == [2, 4]
      assert number_to_list(246) == [2, 4, 6]
      assert number_to_list(2466) == [2, 4, 6, 6]
      assert number_to_list(24667) == [2, 4, 6, 6, 7]
      assert number_to_list(246678) == [2, 4, 6, 6, 7, 8]
    end
  end
end

Part1.count_passwords(246515, 739105) |> IO.inspect(label: "Part1")
