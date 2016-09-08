require_relative '../app/bitmap_editor'

RSpec.describe BitmapEditor do
  subject { described_class.new }

  describe '#execute_input' do
    context 'input is I 30 42' do
      before do
        allow(subject).to receive(:create_new_bitmap).and_call_original
        subject.execute_input 'I 30 42'
      end

      it 'calls create_new_bitmap with the width and height' do
        expect(subject).to have_received(:create_new_bitmap).with('30', '42')
      end

      it 'creates a new BitMap' do
        expect(subject.bitmap).to be_a BitmapEditor::Bitmap
      end

      it 'initializes the new Bitmap with the width and height' do
        expect(subject.bitmap.width).to eq 30
        expect(subject.bitmap.height).to eq 42
      end
    end

    context 'input is C' do
      let(:command) { 'C' }

      it_behaves_like 'a command that requires a bitmap'

      it 'clears the bitmap' do
        bitmap = double()
        allow(bitmap).to receive(:clear)

        subject.execute_input command, bitmap: bitmap

        expect(bitmap).to have_received(:clear)
      end
    end

    context 'input is L 2 2 R' do
      let(:command) { 'L 2 2 R' }

      it_behaves_like 'a command that requires a bitmap'

      it 'colors that pixel on the bitmap' do
        bitmap = double()
        allow(bitmap).to receive(:set_color)

        subject.execute_input command, bitmap: bitmap

        expect(bitmap).to have_received(:set_color).with('2', '2', 'R')
      end
    end

    context 'input is V 2 1 2 R' do
      let(:command) { 'V 2 1 2 R' }

      it_behaves_like 'a command that requires a bitmap'

      it 'draws a vertical line' do
        bitmap = double()
        allow(bitmap).to receive(:vertical_line)

        subject.execute_input command, bitmap: bitmap

        expect(bitmap).to have_received(:vertical_line).with('2', '1', '2','R')
      end
    end

    context 'input is H 3 2 3 R' do
      let(:command) { 'H 3 2 3 R' }

      it_behaves_like 'a command that requires a bitmap'

      it 'draws a horizontal line' do
        bitmap = double()
        allow(bitmap).to receive(:horizontal_line)

        subject.execute_input command, bitmap: bitmap

        expect(bitmap).to have_received(:horizontal_line).with('3', '3', '2', 'R')
      end
    end

    context 'input is ?' do
      it 'prints the help text' do
        expect { subject.execute_input '?' }.to output(subject.help_text).to_stdout
      end
    end

    context 'input is X' do
      it 'prints goodbye' do
        expect { subject.execute_input 'X' }.to output("Goodbye!\n").to_stdout
      end

      it 'sets running to false to exit the app' do
        expect { subject.execute_input 'X' }.to change(subject, :running).to(false)
      end
    end

    context 'with unknown input' do
      it 'prints \'unrecognised command\' and the help' do
        expected = "Unrecognised command\n\n" + subject.help_text

        expect { subject.execute_input 'ABC' }.to output(expected).to_stdout
      end
    end
  end
end
