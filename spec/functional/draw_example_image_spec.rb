require_relative '../../app/editor'

RSpec.describe 'Drawing the example image' do
  describe 'Inputting I 5 6, L 2 3 A, S' do
    let(:first_expected_pattern) {
      # Note: It would be neater to use the <<~ heredoc syntax here but ruby 2.3.0 has a parsing bug
      # https://github.com/rspec/rspec-core/issues/2163
      <<-HEREDOC
OOOOO
OOOOO
OAOOO
OOOOO
OOOOO
OOOOO
      HEREDOC
    }

    let(:second_expected_pattern) {
      <<-HEREDOC
OOOOO
OOZZZ
OWOOO
OWOOO
OWOOO
OWOOO
      HEREDOC
    }

    it 'prints the expected output' do
      bitmap_editor = Editor.new
      bitmap_editor.process_input 'I 5 6'
      bitmap_editor.process_input 'L 2 3 A'

      expect { bitmap_editor.process_input 'S' }.to output(first_expected_pattern).to_stdout

      bitmap_editor.process_input 'V 2 3 6 W'
      bitmap_editor.process_input 'H 3 5 2 Z'

      expect { bitmap_editor.process_input 'S' }.to output(second_expected_pattern).to_stdout
    end
  end

  describe 'Inputting an unrecognised command' do
    it 'prints out an error message' do
      bitmap_editor = Editor.new

      expect { bitmap_editor.process_input 'ABC' }.to output("Error: Unrecognised command\n").to_stdout
    end
  end

  describe 'Wanting to see the help' do
    let(:help_text) {
      <<-HEREDOC
Help:

I M N       - Create a new M x N image with all pixels coloured white (O).
C           - Clears the table, setting all pixels to white (O).
L X Y C     - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
S           - Show the contents of the current image
X           - Terminate the session
      HEREDOC
    }
    it 'prints out the help text' do
      bitmap_editor = Editor.new

      expect { bitmap_editor.process_input '?' }.to output(help_text).to_stdout
    end
  end
end
