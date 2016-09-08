class BitmapEditor
  class Bitmap

    MIN_WIDTH = MIN_HEIGHT = 1
    MAX_WIDTH = MAX_HEIGHT = 250

    attr_reader :width, :height, :errors

    def initialize(width, height)
      @width, @height = Integer(width), Integer(height)
      @cells = initialize_cells if valid?
    end

    def valid?
      @errors = []

      unless width.between?(MIN_WIDTH,MAX_WIDTH) && height.between?(MIN_HEIGHT,MAX_HEIGHT)
        @errors << "Image width and height must be between #{MIN_WIDTH}-#{MAX_WIDTH} and #{MIN_HEIGHT}-#{MAX_HEIGHT} respectively"
      end

      @errors.empty?
    end

    def print_errors
      errors.join "\n"
    end

    private

    def initialize_cells
      Array.new(width) { Array.new(height) { "0" } }
    end
  end
end
