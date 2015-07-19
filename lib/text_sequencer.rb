require 'text_sequencer/version'
require 'text_sequencer/sequencer'
require 'text_sequencer/parser'

# Text Sequencer
module TextSequencer
  def self.parse(text)
    Sequencer.new.parse(text)
  end
end
