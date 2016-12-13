class Display


  def initialize(height, width)
    @height  = height
    @width   = width
    @display = (1..@height).map do
      (1..@width).to_a.map { "." }
    end
  end

  def rect(width, height)
    (0..height-1).to_a.each do |h|
      (0..width-1).to_a.each do |w|
        @display[h][w] = "#"
      end
    end

    self
  end

  def rotate_column(col, count)
    col_array = @display.map { |row| row[col] }.rotate(-count)
    col_array.each_with_index { |elem, idx| @display[idx][col] = elem }

    self
  end

  def rotate_row(row, count)
    @display[row].rotate!(-count)

    self
  end

end
