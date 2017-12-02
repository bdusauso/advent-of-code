file = open("input.txt")
content = file.read().strip()
input = [int(c) for c in content]

def captcha(digits, dist_fun):
  distance = dist_fun(digits)

  digits += digits[:distance]

  sum = 0

  for index, digit in enumerate(digits[:-distance]):
    if digit == digits[index + distance]:
      sum += digit

  return sum

next_digit = lambda i: 1
halfway_around = lambda i: int(len(i) / 2)

print(captcha([1, 1, 2, 2], next_digit))
print(captcha([1, 1, 1, 1], next_digit))
print(captcha([1, 2, 3, 4], next_digit))
print(captcha([9, 1, 2, 1, 2, 1, 2, 9], next_digit))

print(captcha([1, 2, 1, 2], halfway_around))
print(captcha([1, 2, 2, 1], halfway_around))
print(captcha([1, 2, 3, 4, 2, 5], halfway_around))
print(captcha([1, 2, 3, 1, 2, 3], halfway_around))
print(captcha([1, 2, 1, 3, 1, 4, 1, 5], halfway_around))

# First part
print(captcha(input, next_digit))

# Second part
print(captcha(input, halfway_around))
