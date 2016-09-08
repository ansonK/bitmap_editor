require_relative '../../app/bitmap_editor/bitmap'

RSpec.describe BitmapEditor::Bitmap do
  subject { described_class.new 3, 3 }

  describe '#initialize' do
    it 'converts width and height to integers' do
      bitmap = described_class.new '1', '2'

      expect(bitmap.width).to eq 1
      expect(bitmap.height).to eq 2
    end

    it 'initializes the cells' do
      expect(subject.instance_variable_get "@cells").to eq([["0"] * 3] * 3)
    end
  end

  describe '#clear' do
    context 'when valid?' do
      it 'sets the cells to be \'0\'' do
        subject.instance_variable_set "@cells", nil
        subject.clear
        expect(subject.instance_variable_get "@cells").to eq([["0"] * 3] * 3)
      end
    end

    context 'when invalid' do
      subject { described_class.new 0, 0 }

      it 'does not change the cells' do
        subject.instance_variable_set "@cells", nil
        subject.clear
        expect(subject.instance_variable_get "@cells").to be_nil
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
