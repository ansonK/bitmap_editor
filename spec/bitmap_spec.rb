require_relative '../app/bitmap'

RSpec.describe Bitmap do
  subject { described_class.new 3, 3, cells: cells }
  let(:cells) { nil }

  let(:blank_cell_array) { [["O"] * 3] * 3 }

  describe '#initialize' do
    it 'takes width and height' do
      bitmap = described_class.new 1, 2

      expect(bitmap.width).to eq 1
      expect(bitmap.height).to eq 2
    end

    it 'initializes the cells' do
      expect(subject.cells).to eq blank_cell_array
    end
  end

  describe '#clear' do
    it 'sets the cells to be \'O\'' do
      subject.clear
      expect(subject.cells).to eq blank_cell_array
    end
  end

  describe '#set_pixel' do
    context 'width and height are valid' do
      it 'sets that pixel to the color' do
        subject.set_pixel 2, 2, 'R'

        expect(subject.cells).to eq ([["O" ,"O", "O"], ["O" ,"R", "O"], ["O" ,"O", "O"]])
      end
    end

    context 'width is too small' do
      it 'does not change the pixel' do
        subject.set_pixel 0, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_pixel 0, 2, 'R').to be_falsey
      end
    end

    context 'width is too large' do
      it 'does not change the pixel' do
        subject.set_pixel 4, 2, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_pixel 4, 2, 'R').to be_falsey
      end
    end

    context 'height too small' do
      it 'does not change the pixel' do
        subject.set_pixel 2, 0, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_pixel 2, 0, 'R').to be_falsey
      end
    end

    context 'height too large' do
      it 'does not change the pixel' do
        subject.set_pixel 2, 4, 'R'
        expect(subject.cells).to eq blank_cell_array
      end

      it 'returns false' do
        expect(subject.set_pixel 2, 4, 'R').to be_falsey
      end
    end
  end
end
