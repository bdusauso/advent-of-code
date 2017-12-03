# Calculate the coordinates of a number on the grid
# beginning at 1 = (0, 0) and going to the right.
# Examples:
# coordinates(1) = (0, 0)
# coordinates(2) = (1, 0)
# coordinates(7) = (-1, -1)
# coordinates(16) = (-1, 2)
# ...
def max_number_on_line(line)
  (2 * line + 1) ** 2
end

def coordinates(number)
  return 0 if number == 1
  
  corners       = [Complex(1, -1), Complex(1, 1), Complex(-1, 1), Complex(-1, -1)]
  displacements = [Complex(0, 1), Complex(-1, 0), Complex(0, -1), Complex(1, 0)]

  line                    = ((Math.sqrt(number) - 1) / 2).ceil()
  line_length             = 2 * line + 1
  max_number_on_line      = line_length ** 2
  numbers_on_side         = (max_number_on_line(line) - max_number_on_line(line - 1)) / 4 
  distance_to_number      = max_number_on_line - number
  quotient                = distance_to_number / numbers_on_side 
  remainder               = distance_to_number % numbers_on_side

  corners[quotient] * line + displacements[quotient] * remainder
end

[1, 12, 23, 1024, 277678].each do |number|
  position = coordinates(number)
  puts "Manhattan distance for #{number}: #{position.imag.abs + position.real.abs}"
end
