require_relative 'bitmap_editor/bitmap'

class BitmapEditor

  attr_reader :running, :bitmap

  def initialize(bitmap: nil)
    @bitmap = bitmap
  end

  def run
    @running = true
    puts "Type ? for Help\n"
    while @running
      print '> '
      execute_input gets.chomp
    end
  end

  def execute_input(input)
    case input
      when /I (\d+) (\d+)/
        create_new_bitmap Integer($1), Integer($2)
      when 'C'
        clear_bitmap
      when /L (\d+) (\d+) ([A-Z])/
        set_color Integer($1), Integer($2), $3
      when /V (\d+) (\d+) (\d+) ([A-Z])/
        vertical_line Integer($1), Integer($2), Integer($3), $4
      when /H (\d+) (\d+) (\d+) ([A-Z])/
        horizontal_line Integer($3), Integer($1), Integer($2), $4
      when 'S'
        print_bitmap
      when '?'
        show_help
      when 'X'
        exit_console
      else
        unrecognised_command
    end
  end

  private

  def create_new_bitmap(width, height)
    bitmap = Bitmap.new(width, height)

    if bitmap.valid?
      @bitmap = bitmap
    else
      puts 'Error: ' + bitmap.print_errors
    end
  end

  def clear_bitmap
    with_bitmap do |bitmap|
      bitmap.clear
    end
  end

  def set_color(row, column, color)
    with_bitmap do |bitmap|
      puts 'Error: that is not a valid pixel' unless bitmap.set_color row, column, color
    end
  end

  def vertical_line(row, start_column, end_column, color)
    with_bitmap do |bitmap|
      puts 'Error: those coordinates are not valid' unless bitmap.vertical_line row, start_column, end_column, color
    end
  end

  def horizontal_line(column, start_row, end_row, color)
    with_bitmap do |bitmap|
      puts 'Error: those coordinates are not valid' unless bitmap.horizontal_line column, start_row, end_row, color
    end
  end

  def print_bitmap
    with_bitmap do |bitmap|
      puts bitmap.print
    end
  end

  def unrecognised_command
    puts "Unrecognised command\n\n"
    show_help
  end

  def exit_console
    puts 'Goodbye!'
    @running = false
  end

  def show_help
    puts help_text
  end

  def with_bitmap(&block)
    if @bitmap
      yield @bitmap
    else
      puts "Error: No Image has been created - please create an Image first"
    end
  end

  def help_text
    <<~HEREDOC
      Help:

      I M N - Create a new M x N image with all pixels coloured white (O).
      C - Clears the table, setting all pixels to white (O).
      L X Y C - Colours the pixel (X,Y) with colour C.
      V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
      H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
      S - Show the contents of the current image
      X - Terminate the session
    HEREDOC
  end
end
