require_relative './response'
require_relative './bitmap_manipulator'

class Editor

  attr_reader :running, :bitmap

  def initialize(bitmap: nil)
    @bitmap = bitmap
  end

  def run
    @running = true
    output_stream.write "Type ? for Help\n"
    while @running
      output_stream.write '> '
      process_input gets.chomp
    end
  end

  def process_input(input)
    response = execute_input(input)
    @bitmap = response.bitmap if response.bitmap
    response.print_message output_stream
  end

  def execute_input(input)
    case input

      when /I (\d+) (\d+)/
        BitmapManipulator.new.create_bitmap width: Integer($1), height: Integer($2)
      when 'C'
        BitmapManipulator.new(bitmap).clear

      when /L (\d+) (\d+) ([A-Z])/
        BitmapManipulator.new(bitmap).set_color row: Integer($1), column: Integer($2), color: $3

      when /V (\d+) (\d+) (\d+) ([A-Z])/
        BitmapManipulator.new(bitmap).vertical_line row: Integer($1), start_column: Integer($2), end_column: Integer($3), color: $4

      when /H (\d+) (\d+) (\d+) ([A-Z])/
        BitmapManipulator.new(bitmap).horizontal_line column: Integer($3), start_row: Integer($1), end_row: Integer($2), color: $4

      when 'S'
        BitmapManipulator.new(bitmap).print_bitmap

      when '?'
        show_help

      when 'X'
        exit_console

      else
        unrecognised_command
    end
  end

  private

  def output_stream
    @output_stream || $stdout
  end

  def unrecognised_command
    Response.new message:  'Error: Unrecognised command'
  end

  def exit_console
    @running = false
    Response.new message: 'Goodbye!'
  end

  def show_help
    Response.new message:  help_text
  end

  def help_text
    <<~HEREDOC
      Help:

      I M N       - Create a new M x N image with all pixels coloured white (O).
      C           - Clears the table, setting all pixels to white (O).
      L X Y C     - Colours the pixel (X,Y) with colour C.
      V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
      H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
      S           - Show the contents of the current image
      X           - Terminate the session
    HEREDOC
  end
end
