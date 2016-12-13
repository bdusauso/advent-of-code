class Display


  def initialize(height, width)
    @height  = height
    @width   = width
    @display = (1..@height).map do
      (1..@width).to_a.map { false }
    end
  end

  def rect(width, height)
    (0..height-1).to_a.each do |h|
      (0..width-1).to_a.each do |w|
        @display[h][w] = true
      end
    end
  end

  def rotate_column(col, count)
    col_array = @display.map { |row| row.fetch(col) }.rotate(-count)
    col_array.each_with_index { |elem, idx| @display[idx][col] = elem }
  end

  def rotate_row(row, count)
    @display.fetch(row).rotate!(-count)
  end

  def to_s
    @display.map do |row|
      row.map { |pixel| pixel ? "#" : "." }.join
    end.join("\n")
  end

  def count_lit
    @display.reduce(0) do |total, row|
      total + row.count { |pixel| pixel }
    end
  end

end

def interpret(instruction, display)
  case instruction
  when /rect (\d+)x(\d+)/
    display.rect($1.to_i, $2.to_i)
  when /rotate row y=(\d+) by (\d+)/
    display.rotate_row($1.to_i, $2.to_i)
  when /rotate column x=(\d+) by (\d+)/
    display.rotate_column($1.to_i, $2.to_i)
  end
  display
end


display = File
  .read("input.txt")
  .split("\n")
  .reduce(Display.new(6, 50)) { |display, instruction| interpret(instruction, display) }

puts display

puts display.count_lit
