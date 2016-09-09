class BitmapEditor
  class Bitmap

    MIN_WIDTH = MIN_HEIGHT = 1
    MAX_WIDTH = MAX_HEIGHT = 250

    attr_reader :width, :height, :cells, :errors

    def initialize(width, height, cells: nil)
      @width, @height, @cells = Integer(width), Integer(height), cells
      clear unless cells
    end

    def valid?
      @errors = []

      unless width.between?(MIN_WIDTH,MAX_WIDTH) && height.between?(MIN_HEIGHT,MAX_HEIGHT)
        @errors << "Image width and height must be between #{MIN_WIDTH}-#{MAX_WIDTH} and #{MIN_HEIGHT}-#{MAX_HEIGHT} respectively"
      end

      @errors.empty?
    end

    def print_errors
      errors.join "\n"
    end

    def clear
      @cells = initialize_cells if valid?
    end

    def set_color(row, column, color)
      return false unless valid_row_index?(row) && valid_column_index?(column)

      @cells[row-1][column-1] = color
      true
    end

    def vertical_line(row, start_column, end_column, color)
      return false unless valid_row_index?(row) && valid_column_indices?(start_column, end_column)

      (start_column-1..end_column-1).each do |column_index|
        @cells[row-1][column_index] = color
      end

      true
    end

    def horizontal_line(column, start_row, end_row, color)
      return false unless valid_column_index?(column) && valid_row_indices?(start_row, end_row)

      (start_row-1..end_row-1).each do |row_index|
        @cells[row_index][column-1] = color
      end

      true
    end

    def print
      "".tap do |output|
        (0..@cells[0].length-1).each do |column_index|
          (0..@cells.length-1).each do |row_index|
            output << @cells[row_index][column_index]
          end
          output << "\n"
        end
      end
    end

    private

    def initialize_cells
      Array.new(width) { Array.new(height) { "O" } }
    end

    def valid_row_index?(row)
      row.between?(1,width)
    end

    def valid_column_index?(column)
      column.between?(1,height)
    end

    def valid_column_indices?(start_column, end_column)
      valid_column_index?(start_column) &&
      valid_column_index?(end_column) &&
      start_column <= end_column
    end

    def valid_row_indices?(start_row, end_row)
      valid_row_index?(start_row) &&
      valid_row_index?(end_row) &&
      start_row <= end_row
    end
  end
end
