defmodule Captcha do
  def captcha(digits, dist_func) do
    distance = dist_func.(digits)
    digits   = digits ++ Enum.take(digits, distance)

    digits
    |> Enum.with_index
    |> Enum.reduce(0, fn {digit, index}, sum -> if Enum.at(digits, index + distance) == digit, do: sum + digit, else: sum; end)
  end
end

next_digit = fn _ -> 1 end
halfway_around = fn digits -> div(length(digits), 2) end

IO.puts Captcha.captcha([1, 1, 2, 2], next_digit)
IO.puts Captcha.captcha([1, 1, 1, 1], next_digit)
IO.puts Captcha.captcha([1, 2, 3, 4], next_digit)
IO.puts Captcha.captcha([9, 1, 2, 1, 2, 1, 2, 9], next_digit)

IO.puts Captcha.captcha([1, 2, 1, 2], halfway_around)
IO.puts Captcha.captcha([1, 2, 2, 1], halfway_around)
IO.puts Captcha.captcha([1, 2, 3, 4, 2, 5], halfway_around)
IO.puts Captcha.captcha([1, 2, 3, 1, 2, 3], halfway_around)
IO.puts Captcha.captcha([1, 2, 1, 3, 1, 4, 1, 5], halfway_around)

input = "input.txt"
        |> File.read!()
        |> String.trim
        |> String.codepoints
        |> Enum.map(&String.to_integer/1)

IO.inspect(input)

IO.puts Captcha.captcha(input, next_digit)
IO.puts Captcha.captcha(input, halfway_around)