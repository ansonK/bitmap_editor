require_relative '../app/bitmap_manipulator'

RSpec.describe BitmapManipulator do
  let(:bitmap) { Bitmap.new 3, 3 }
  subject { described_class.new bitmap }

  describe '#create_bitmap' do
    subject { described_class.new }

    context 'with a valid width and height' do
      it 'responds with a new bitmap' do
        response = subject.create_bitmap width: 10, height: 10

        expect(response.bitmap).to be_a Bitmap
        expect(response.bitmap.width).to eq 10
        expect(response.bitmap.height).to eq 10
      end
    end

    context 'with invalid dimensions' do
      it 'responds with an error' do
        response = subject.create_bitmap width: 0, height: 0

        expect(response.bitmap).to be_nil
        expect(response.message).to eq "Error: Image width and height must be between #{Bitmap::MIN_WIDTH}-#{Bitmap::MAX_WIDTH} and #{Bitmap::MIN_HEIGHT}-#{Bitmap::MAX_HEIGHT} respectively"
      end
    end
  end

  describe '#clear' do
    context 'with no current bitmap' do
      let(:bitmap) { nil }

      it 'responds with an error message' do
        response = subject.clear

        expect(response.message).to eq 'Error: No Image has been created - please create an Image first'
      end
    end

    context 'with a current bitmap' do
      context 'when the bitmap can be cleared' do
        before do
          expect(bitmap).to receive(:clear).and_return true
        end

        it 'responds with no message' do
          response = subject.clear

          expect(response.message).to be_nil
        end
      end

      context 'when the bitmap cannot be cleared' do
        before do
          expect(bitmap).to receive(:clear).and_return false
        end

        it 'responds with an error message' do
          response = subject.clear

          expect(response.message).to eq 'Error: Could not clear Image'
        end
      end
    end
  end

  describe '#set_color' do
    context 'with no current bitmap' do
      let(:bitmap) { nil }

      it 'responds with an error message' do
        response = subject.set_color row: 1, column: 2, color: 'R'

        expect(response.message).to eq 'Error: No Image has been created - please create an Image first'
      end
    end

    context 'with a current bitmap' do
      it 'attempts to set the pixel color on the bitmap' do
        allow(bitmap).to receive(:set_pixel)

        subject.set_color row: 1, column: 2, color: 'R'

        expect(bitmap).to have_received(:set_pixel).with(1, 2, 'R')
      end

      context 'when setting the pixel succeeded' do
        before do
          expect(bitmap).to receive(:set_pixel).and_return true
        end

        it 'responds with no message' do
          response = subject.set_color row: 1, column: 2

          expect(response.message).to be_nil
        end
      end

      context 'when setting the pixel failed' do
        before do
          expect(bitmap).to receive(:set_pixel).and_return false
        end

        it 'responds with an error message' do
          response = subject.set_color row: 1, column: 2

          expect(response.message).to eq 'Error: that is not a valid pixel'
        end
      end
    end
  end

  describe '#vertical_line' do
    context 'with no current bitmap' do
      let(:bitmap) { nil }

      it 'responds with an error message' do
        response = subject.vertical_line row: 2, start_column: 1, end_column: 2, color: 'R'

        expect(response.message).to eq 'Error: No Image has been created - please create an Image first'
      end
    end

    context 'with a current bitmap' do
      before do
        allow(bitmap).to receive(:set_pixel)
      end

      context 'with valid coordinates' do
        it 'sets the expected pixels' do
          subject.vertical_line row: 2, start_column: 1, end_column: 2, color: 'R'

          expect(bitmap).to have_received(:set_pixel).with(2, 1, 'R').once
          expect(bitmap).to have_received(:set_pixel).with(2, 2, 'R').once
        end

        it 'responds with no message' do
          response = subject.vertical_line row: 2, start_column: 1, end_column: 2, color: 'R'

          expect(response.message).to be_nil
        end
      end

      context 'with invalid coordinates' do
        it 'does not try to set pixels' do
          subject.vertical_line row: 2, start_column: 4, end_column: 2, color: 'R'

          expect(bitmap).not_to have_received(:set_pixel)
        end

        it 'responds with an error message' do
          response = subject.vertical_line row: 2, start_column: 4, end_column: 2, color: 'R'

          expect(response.message).to eq 'Error: those coordinates are not valid'
        end
      end
    end
  end

  describe '#horizontal_line' do
    context 'with no current bitmap' do
      let(:bitmap) { nil }

      it 'responds with an error message' do
        response = subject.horizontal_line column: 2, start_row: 1, end_row: 2, color: 'R'

        expect(response.message).to eq 'Error: No Image has been created - please create an Image first'
      end
    end

    context 'with a current bitmap' do
      before do
        allow(bitmap).to receive(:set_pixel)
      end

      context 'with valid coordinates' do
        it 'sets the expected pixels' do
          subject.horizontal_line column: 2, start_row: 1, end_row: 2, color: 'R'

          expect(bitmap).to have_received(:set_pixel).with(1, 2, 'R').once
          expect(bitmap).to have_received(:set_pixel).with(2, 2, 'R').once
        end

        it 'responds with no message' do
          response = subject.horizontal_line column: 2, start_row: 1, end_row: 2, color: 'R'

          expect(response.message).to be_nil
        end
      end

      context 'with invalid coordinates' do
        it 'does not try to set pixels' do
          subject.horizontal_line column: 4, start_row: 1, end_row: 2, color: 'R'

          expect(bitmap).not_to have_received(:set_pixel)
        end

        it 'responds with an error message' do
          response = subject.horizontal_line column: 4, start_row: 1, end_row: 2, color: 'R'

          expect(response.message).to eq 'Error: those coordinates are not valid'
        end
      end
    end
  end

  describe '#print_bitmap' do
    context 'with no current bitmap' do
      let(:bitmap) { nil }

      it 'responds with an error message' do
        response = subject.print_bitmap

        expect(response.message).to eq 'Error: No Image has been created - please create an Image first'
      end
    end

    context 'with a current bitmap' do
      it 'responds with the printed bitmap' do
        allow(bitmap).to receive(:print).and_return 'foobars'

        response = subject.print_bitmap

        expect(response.message).to eq 'foobars'
      end
    end
  end
end
