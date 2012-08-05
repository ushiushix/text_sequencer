require 'midilib'

module TextSequencer
  class MidilibExporter
    def initialize(track)
      raise ArgumentError, "Not MIDI::Track object: #{track}" unless track.is_a? MIDI::Track
      @track = track
      @prev_delay = 0
    end

    def export(parser)
      parser.sequence.each do |s|
        translate(s)
      end
    end

    private
    def translate(record)
      case record.first
      when :note
        sym, note, length, delay, velocity = record
        @track.events <<
          NoteOn.new(0, note, velocity,
                     @track.sequence.length_to_delta(@prev_delay))
        @track.events <<
          NoteOff.new(0, note, velocity,
                      @track.sequence.length_to_delta(length))
        @prev_delay = delay - length
      else
      end
    end
  end
end
