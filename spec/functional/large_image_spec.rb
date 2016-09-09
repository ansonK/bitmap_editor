require_relative '../../app/bitmap_editor'

RSpec.describe 'Drawing a large image 250x250' do
  describe 'a large blank image' do
    let(:expected_pattern) {
      ("O" * 250 << "\n") * 250
    }

    it 'prints the expected output' do
      bitmap_editor = BitmapEditor.new
      bitmap_editor.execute_input 'I 250 250'

      expect { bitmap_editor.execute_input 'S' }.to output(expected_pattern).to_stdout
    end
  end

  describe 'drawing a cross pattern' do
    let(:expected_pattern) {
      File.read File.expand_path('../../../spec/support/large_cross_pattern.txt', __FILE__)
    }

    it 'prints the expected output' do
      bitmap_editor = BitmapEditor.new
      bitmap_editor.execute_input 'I 250 250 R'
      bitmap_editor.execute_input 'V 124 1 250 R'
      bitmap_editor.execute_input 'V 125 1 250 R'
      bitmap_editor.execute_input 'V 126 1 250 R'
      bitmap_editor.execute_input 'H 1 250 124 R'
      bitmap_editor.execute_input 'H 1 250 125 R'
      bitmap_editor.execute_input 'H 1 250 126 R'

      expect { bitmap_editor.execute_input 'S' }.to output(expected_pattern).to_stdout
    end
  end
end
