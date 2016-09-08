require_relative 'bitmap_editor/bitmap'

class BitmapEditor

  attr_reader :running, :bitmap, :interactive

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
        create_new_bitmap $1, $2
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

  public

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
