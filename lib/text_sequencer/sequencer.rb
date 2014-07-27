module TextSequencer
  class Sequencer
    attr_accessor :sequence

    def initialize(parser: TextSequencer::Parser)
      @sequence = []
      @parser = parser.new(self)
    end

    def export(exporter)
      exporter.export(self)
    end

    def parse(text)
      @parser.parse(text)
      self
    end
  end
end
