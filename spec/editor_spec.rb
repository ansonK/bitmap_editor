require_relative '../app/editor'

RSpec.describe Editor do
  subject { described_class.new bitmap: bitmap }
  let(:bitmap) { nil }

  describe '#process_input' do
    let(:response) { instance_double(Response) }

    before do
      allow(subject).to receive(:execute_input).and_return response
      allow(response).to receive(:bitmap)
      allow(response).to receive(:print_message)
    end

    it 'calls execute_input with the input' do
      subject.process_input 'ABC'

      expect(subject).to have_received(:execute_input).with('ABC')
    end

    it 'tells the response to print itself' do
      subject.process_input 'ABC'

      expect(response).to have_received(:print_message).with($stdout)
    end

    context 'when the response contains a bitmap' do
      let(:response) { instance_double(Response, bitmap: bitmap) }
      let(:bitmap) { instance_double(Bitmap) }

      it 'keeps the bitmap' do
        subject.process_input 'ABC'

        expect(subject.bitmap).to eq bitmap
      end
    end
  end

  describe '#execute_input' do
    let(:mock_bitmap_manipulator) { instance_double BitmapManipulator }

    before do
      allow(BitmapManipulator).to receive(:new).and_return mock_bitmap_manipulator
    end

    context 'input is I 30 42' do
      before do
        allow(mock_bitmap_manipulator).to receive(:create_bitmap).and_return 'foo'
      end

      it 'calls BitmapManipulator#create_bitmap with the width and height' do
        subject.execute_input 'I 30 42'

        expect(mock_bitmap_manipulator).to have_received(:create_bitmap).with(width: 30, height: 42)
      end

      it 'returns the response from BitmapManipulator#create_bitmap' do
        expect(subject.execute_input 'I 30 42').to eq 'foo'
      end
    end

    context 'input is C' do
      before do
        allow(mock_bitmap_manipulator).to receive(:clear).and_return 'foo'
      end

      it 'calls BitmapManipulator#clear with the width and height' do
        subject.execute_input 'C'

        expect(mock_bitmap_manipulator).to have_received(:clear)
      end

      it 'returns the response from BitmapManipulator#create_bitmap' do
        expect(subject.execute_input 'C').to eq 'foo'
      end
    end

    context 'input is L 2 2 R' do
      before do
        allow(mock_bitmap_manipulator).to receive(:set_color).and_return 'foo'
      end

      it 'calls BitmapManipulator#set_color with the width and height' do
        subject.execute_input 'L 2 2 R'

        expect(mock_bitmap_manipulator).to have_received(:set_color).with(row: 2, column: 2, color: 'R')
      end

      it 'returns the response from BitmapManipulator#create_bitmap' do
        expect(subject.execute_input 'L 2 2 R').to eq 'foo'
      end
    end

    context 'input is V 2 1 2 R' do
      before do
        allow(mock_bitmap_manipulator).to receive(:vertical_line).and_return 'foo'
      end

      it 'calls BitmapManipulator#vertical_line with the width and height' do
        subject.execute_input 'V 2 1 2 R'

        expect(mock_bitmap_manipulator).to have_received(:vertical_line).with(row: 2, start_column: 1, end_column: 2, color: 'R')
      end

      it 'returns the response from BitmapManipulator#create_bitmap' do
        expect(subject.execute_input 'V 2 1 2 R').to eq 'foo'
      end
    end

    context 'input is H 1 2 4 R' do
      before do
        allow(mock_bitmap_manipulator).to receive(:horizontal_line).and_return 'foo'
      end

      it 'calls BitmapManipulator#horizontal_line with the width and height' do
        subject.execute_input 'H 1 2 4 R'

        expect(mock_bitmap_manipulator).to have_received(:horizontal_line).with(column: 4, start_row: 1, end_row: 2, color: 'R')
      end

      it 'returns the response from BitmapManipulator#create_bitmap' do
        expect(subject.execute_input 'H 1 2 4 R').to eq 'foo'
      end
    end

    context 'input is ?' do
      it 'responds with the help text' do
        response = subject.execute_input '?'

        expect(response.message).to eq(subject.send :help_text)
      end
    end

    context 'input is X' do
      it 'responds with a goodbye message' do
        response = subject.execute_input 'X'

        expect(response.message).to eq 'Goodbye!'
      end

      it 'sets running to false to exit the app' do
        expect { subject.execute_input 'X' }.to change(subject, :running).to(false)
      end
    end

    context 'with unknown input' do
      it 'responds with Unrecognised command message' do
        response = subject.execute_input 'ABC'

        expect(response.message).to eq 'Error: Unrecognised command'
      end
    end
  end
end
