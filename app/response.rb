class Response

  attr_reader :bitmap, :message

  def initialize(bitmap: nil, message: nil)
    @bitmap, @message = bitmap, message
  end

  def print_message(io_stream)
    return unless message

    io_stream.write message.chomp ''
    io_stream.write "\n"
  end
end
