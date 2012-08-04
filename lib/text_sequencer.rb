require "text_sequencer/version"
require "text_sequencer/parser"

module TextSequencer
  def self.parse(text)
    Parser.new.parse(text)
  end
end
