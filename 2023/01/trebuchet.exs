defmodule Trebuchet do
  @spelling %{
    "nine" => "9",
    "eight" => "8",
    "seven" => "7",
    "six" => "6",
    "five" => "5",
    "four" => "4",
    "three" => "3",
    "two" => "2",
    "one" => "1",
    "zero" => "0"
  }

  @spelling_regex ~r/(?=(zero|one|two|three|four|five|six|seven|eight|nine))/

  def calibrate(str, replace \\ false) do
    str = if replace, do: replace_spelling(str), else: str

    digits =
      str
      |> String.to_charlist()
      |> Enum.filter(& &1 in ?0..?9)

    [Enum.at(digits, 0), Enum.at(digits, -1)]
    |> List.to_integer()
  end

  defp replace_spelling(str) do
    Regex.replace(@spelling_regex, str, fn _, c1 -> @spelling[c1] end)
  end
end

ExUnit.start()

defmodule TrebuchetTest do
  use ExUnit.Case

  import Trebuchet

  test "calibrate/1 without replacement" do
    assert calibrate("1abc2") == 12
    assert calibrate("pqr3stu8vwx") == 38
    assert calibrate("a1b2c3d4e5f") == 15
    assert calibrate("treb7uchet") == 77
  end

  test "calibrate/1 with replacement" do
    assert calibrate("two1nine", true) == 29
    assert calibrate("eightwothree", true) == 83
    assert calibrate("abcone2threexyz", true) == 13
    assert calibrate("xtwone3four", true) == 24
    assert calibrate("zoneight234", true) == 14
    assert calibrate("7pqrstsixteen", true) == 76
  end
end

input =
  "input.txt"
  |> File.stream!()

calibration_sum_1 =
  input
  |> Enum.map(&Trebuchet.calibrate/1)
  |> Enum.sum()

IO.puts("Calibration sum part 1: #{calibration_sum_1}")


calibration_sum_2 =
  input
  |> Enum.map(&Trebuchet.calibrate(&1, true))
  |> Enum.sum()

IO.puts("Calibration sum part 2: #{calibration_sum_2}")
