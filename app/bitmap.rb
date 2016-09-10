
class Bitmap

  MIN_WIDTH = MIN_HEIGHT = 1
  MAX_WIDTH = MAX_HEIGHT = 250
  WHITE = "O".freeze

  attr_reader :width, :height, :cells, :errors

  def initialize(width, height, cells: nil)
    @width, @height, @cells = Integer(width), Integer(height), cells
    clear unless cells
  end

  def print
    "".tap do |output|
      (0..cells[0].length-1).each do |column_index|
        (0..cells.length-1).each do |row_index|
          output << cells[row_index][column_index]
        end
        output << "\n"
      end
    end
  end

  def clear
    @cells = initialize_cells
  end

  def set_pixel(row, column, color)
    return false unless valid_coordinate?(row, column)

    cells[row-1][column-1] = color
  end

  def valid_coordinate?(row, column)
    valid_row_index?(row) && valid_column_index?(column)
  end

  def valid_row_index?(row)
    row.between?(1,width)
  end

  def valid_column_index?(column)
    column.between?(1,height)
  end

  private

  def initialize_cells
    Array.new(width) { Array.new(height) { WHITE } }
  end
end
