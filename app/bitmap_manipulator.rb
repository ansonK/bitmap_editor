require_relative './bitmap'
require_relative './response'

class BitmapManipulator

  def initialize(bitmap = nil)
    @bitmap = bitmap
  end

  def create_bitmap(width:, height:)
    if width.between?(Bitmap::MIN_WIDTH, Bitmap::MAX_WIDTH) && height.between?(Bitmap::MIN_HEIGHT,Bitmap::MAX_HEIGHT)
      send_response bitmap: Bitmap.new(width, height)
    else
      send_response message: "Error: Image width and height must be between #{Bitmap::MIN_WIDTH}-#{Bitmap::MAX_WIDTH} and #{Bitmap::MIN_HEIGHT}-#{Bitmap::MAX_HEIGHT} respectively"
    end
  end

  def clear
    return no_bitmap_response unless bitmap

    if bitmap.clear
      send_response
    else
      send_response message: 'Error: Could not clear Image'
    end
  end

  def set_color(row:, column:, color: Bitmap::WHITE)
    return no_bitmap_response unless bitmap

    if bitmap.set_pixel row, column, color
      send_response
    else
      send_response message: 'Error: that is not a valid pixel'
    end
  end

  def vertical_line(row:, start_column:, end_column:, color: Bitmap::WHITE)
    return no_bitmap_response unless bitmap

    if valid_vertical_line_coordinates?(row, start_column, end_column)

      (start_column..end_column).each do |column_index|
        bitmap.set_pixel row, column_index, color
      end

      send_response
    else
      send_response message: 'Error: those coordinates are not valid'
    end
  end

  def horizontal_line(column:, start_row:, end_row:, color: Bitmap::WHITE)
    return no_bitmap_response unless bitmap

    if valid_horizontal_line_coordinates?(column, start_row, end_row)

      (start_row..end_row).each do |row_index|
        bitmap.set_pixel row_index, column, color
      end

      send_response
    else
      send_response message: 'Error: those coordinates are not valid'
    end
  end

  def print_bitmap
    return no_bitmap_response unless bitmap

    send_response message: bitmap.print
  end

  private

  attr_reader :bitmap

  def send_response(message: nil, bitmap: nil)
    Response.new bitmap: bitmap, message: message
  end

  def no_bitmap_response
    Response.new message: 'Error: No Image has been created - please create an Image first'
  end

  def valid_vertical_line_coordinates?(row, start_column, end_column)
    bitmap &&
    bitmap.valid_row_index?(row) &&
    bitmap.valid_column_index?(start_column) &&
    bitmap.valid_column_index?(end_column) &&
    start_column <= end_column
  end

  def valid_horizontal_line_coordinates?(column, start_row, end_row)
    bitmap &&
    bitmap.valid_column_index?(column) &&
    bitmap.valid_row_index?(start_row) &&
    bitmap.valid_row_index?(end_row) &&
    start_row <= end_row
  end
end
