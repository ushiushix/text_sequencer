require 'text_sequencer/version'
require 'text_sequencer/sequencer'
require 'text_sequencer/parser'

module TextSequencer
  def self.parse(text)
    Sequencer.new.parse(text)
  end
end
