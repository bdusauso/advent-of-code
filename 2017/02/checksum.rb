def from_file(file)
  File.read(file)
      .strip
      .split("\n")
      .map(&:split)
      .map { |row| row.map { |s| Integer(s) }}
end

def checksum(matrix, acc_fun)
  matrix.reduce(0) { |acc, row| acc += acc_fun.call(row, acc) }
end

max_diff = -> (row, acc) { (row.max - row.min) }

# Tests
puts checksum([[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]], max_diff)

matrix = from_file("input.txt")
puts checksum(matrix, max_diff)
