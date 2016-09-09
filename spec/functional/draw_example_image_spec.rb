require_relative '../../app/bitmap_editor'

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
      bitmap_editor = BitmapEditor.new
      bitmap_editor.execute_input 'I 5 6'
      bitmap_editor.execute_input 'L 2 3 A'

      expect { bitmap_editor.execute_input 'S' }.to output(first_expected_pattern).to_stdout

      bitmap_editor.execute_input 'V 2 3 6 W'
      bitmap_editor.execute_input 'H 3 5 2 Z'

      expect { bitmap_editor.execute_input 'S' }.to output(second_expected_pattern).to_stdout
    end
  end
end
