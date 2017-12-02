def captcha(input, dist_fun)
  distance = dist_fun.call(input)

  input += input.slice(0, distance)

  sum = 0

  input[0, input.size - distance].each_with_index do |digit, index|
    sum += digit if digit == input[index + distance]
  end

  sum
end

next_digit     = ->(input) { 1 }
halfway_around = ->(input) { input.size / 2 }

puts captcha([1, 1, 2, 2], next_digit)
puts captcha([1, 1, 1, 1], next_digit)
puts captcha([1, 2, 3, 4], next_digit)
puts captcha([9, 1, 2, 1, 2, 1, 2, 9], next_digit)

puts captcha([1, 2, 1, 2], halfway_around)
puts captcha([1, 2, 2, 1], halfway_around)
puts captcha([1, 2, 3, 4, 2, 5], halfway_around)
puts captcha([1, 2, 3, 1, 2, 3], halfway_around)
puts captcha([1, 2, 1, 3, 1, 4, 1, 5], halfway_around)


# First part
input = File.read("input.txt")
            .strip
            .each_char
            .map { |c| Integer(c) }

puts captcha(input, next_digit)

# Second part
puts captcha(input, halfway_around)
