class BitmapEditor
  class Bitmap

    attr_reader :width, :height

    def initialize(width, height)
      @width, @height = Integer(width), Integer(height)
      @cells = initialize_cells
    end

    private

    def initialize_cells
      Array.new(width) { Array.new(height) { "0" } }
    end
  end
end
