require_relative '../app/response'

RSpec.describe Response do
  describe '#initialize' do
    it 'takes a bitmap and message' do
      bitmap, message = double(), 'abc'

      response = described_class.new bitmap: bitmap, message: message

      expect(response.bitmap).to eq(bitmap)
      expect(response.message).to eq(message)
    end
  end

  describe '#print_message' do
    subject { described_class.new message: message }
    let(:io_stream) { StringIO.new }

    context 'with no message' do
      let(:message) { nil }

      it 'writes nothing to the stream' do
        subject.print_message io_stream

        expect(io_stream.string).to be_empty
      end
    end

    context 'with a message' do
      let(:message) { "abcde\n\n" }

      it 'writes the message with 1 newline to the stream' do
        subject.print_message io_stream

        expect(io_stream.string).to eq "abcde\n"
      end
    end
  end
end
