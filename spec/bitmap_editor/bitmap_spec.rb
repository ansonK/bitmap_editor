require_relative '../../app/bitmap_editor/bitmap'

RSpec.describe BitmapEditor::Bitmap do
  subject { described_class.new 3, 3, cells: cells }
  let(:cells) { nil }

  let(:blank_cell_array) { [["O"] * 3] * 3 }

  describe '#initialize' do
    it 'converts width and height to integers' do
      bitmap = described_class.new '1', '2'

      expect(bitmap.width).to eq 1
      expect(bitmap.height).to eq 2
    end

    it 'initializes the cells' do
      expect(subject.cells).to eq blank_cell_array
    end
  end

  describe '#clear' do
    context 'when valid?' do
      it 'sets the cells to be \'O\'' do
        subject.clear
        expect(subject.cells).to eq blank_cell_array
      end
    end

    context 'when invalid' do
      subject { described_class.new 0, 0 }

      it 'does not change the cells' do
        subject.clear
        expect(subject.cells).to be_nil
      end
    end
  end

  describe '#set_color' do
    context 'width and height are valid' do
      it 'sets that pixel to the color' do
        subject.set_color 2, 2, 'R'

        expect(subject.cells).to eq ([["O" ,"O", "O"], ["O" ,"R", "O"], ["O" ,"O", "O"]])
      end
    end

    context 'width is invalid' do
      it 'does not change the pixel' do
        subject.set_color 4, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_color 4, 2, 'R').to be_falsey
      end
    end

    context 'height is invalid' do
      it 'does not change the pixel' do
        subject.set_color 2, 4, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_color 2, 4, 'R').to be_falsey
      end
    end
  end

  describe '#vertical_line' do
    context 'with valid bounds' do
      it 'sets the pixels on column X to the color' do
        subject.vertical_line 2, 1, 2, 'R'
        expect(subject.cells).to eq ([["O" ,"O", "O"], ["R" ,"R", "O"], ["O" ,"O", "O"]])
      end
    end

    context 'with an invalid row' do
      it 'does not change any pixels' do
        subject.vertical_line 10, 1, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.vertical_line 10, 1, 2, 'R').to be_falsey
      end
    end

    context 'with an invalid start_column' do
      it 'does not change any pixels' do
        subject.vertical_line 2, -1, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.vertical_line 2, -1, 2, 'R').to be_falsey
      end
    end

    context 'with an invalid end_column' do
      it 'does not change any pixels' do
        subject.vertical_line 2, 1, 20, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.vertical_line 2, 1, 20, 'R').to be_falsey
      end
    end

    context 'start_column is larger than end_column' do
      it 'does not change any pixels' do
        subject.vertical_line 2, 2, 1, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.vertical_line 2, 2, 1, 'R').to be_falsey
      end
    end
  end

  describe '#horizontal_line' do
    context 'with valid bounds' do
      it 'sets the pixels on column X to the color' do
        subject.horizontal_line 2, 2, 3, 'R'
        expect(subject.cells).to eq ([["O" ,"O", "O"], ["O" ,"R", "O"], ["O" ,"R", "O"]])
      end
    end

    context 'with an invalid column' do
      it 'does not change any pixels' do
        subject.horizontal_line 20, 2, 3, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.horizontal_line 20, 1, 2, 'R').to be_falsey
      end
    end

    context 'with an invalid start_row' do
      it 'does not change any pixels' do
        subject.horizontal_line 2, 0, 3, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.horizontal_line 2, 0, 3, 'R').to be_falsey
      end
    end

    context 'with an invalid end_row' do
      it 'does not change any pixels' do
        subject.horizontal_line 2, 2, 4, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.horizontal_line 2, 2, 4, 'R').to be_falsey
      end
    end

    context 'start_row is larger than end_row' do
      it 'does not change any pixels' do
        subject.horizontal_line 2, 3, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.horizontal_line 2, 3, 2, 'R').to be_falsey
      end
    end
  end

  describe '#valid?' do
    context 'when the Bitmap is valid' do
      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end

      it 'has no errors' do
        expect(subject.errors).to be_empty
      end
    end

    context 'width is too small' do
      subject { described_class.new BitmapEditor::Bitmap::MIN_WIDTH-1, 10 }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end

      it 'has an error message' do
        expect(subject.errors).not_to be_empty
      end
    end

    context 'width is too large' do
      subject { described_class.new BitmapEditor::Bitmap::MAX_WIDTH + 1, 10 }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end

      it 'has an error message' do
        expect(subject.errors).not_to be_empty
      end
    end

    context 'height is too small' do
      subject { described_class.new 10, BitmapEditor::Bitmap::MIN_HEIGHT-1 }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end

      it 'has an error message' do
        expect(subject.errors).not_to be_empty
      end
    end

    context 'height is too large' do
      subject { described_class.new 10, BitmapEditor::Bitmap::MAX_HEIGHT + 1 }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end

      it 'has an error message' do
        expect(subject.errors).not_to be_empty
      end
    end
  end
end
