defmodule Part1 do
  def count_passwords(from, to) do
    Enum.count(from..to, &candidate?(&1, from, to))
  end

  def candidate?(number, from, to) when number in from..to do
    number_list = Integer.digits(number)
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
end

Part1.count_passwords(246515, 739105) |> IO.inspect(label: "Part1")
