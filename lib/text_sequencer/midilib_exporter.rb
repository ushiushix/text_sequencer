require 'midilib'

module TextSequencer
  # Export note sequence to MIDI using midilib.
  class MidilibExporter
    include MIDI

    def initialize(track, channel = 0)
      fail ArgumentError, "Not MIDI::Track object: #{track}" unless track.is_a? MIDI::Track
      @track = track
      @channel = channel
      @prev_delay = 0
    end

    def export(parser)
      parser.sequence.each do |s|
        translate(s)
      end
      @track.recalc_times
      @track.recalc_delta_from_times
    end

    private

    def translate(record)
      case record.first
      when :note
        _sym, note, length, delay, velocity = record
        if note
          @track.events <<
            NoteOn.new(@channel, note, velocity,
                       @track.sequence.length_to_delta(@prev_delay))
          @track.events <<
            NoteOff.new(@channel, note, velocity,
                        @track.sequence.length_to_delta(length))
          @prev_delay = delay - length
        else
          @prev_delay += delay
        end
      when :pitch_bend
        _sym, val, delay = record
        # midilib accepts val between 0 and 16383
        val += 8192
        @track.events << PitchBend.new(@channel, val,
                                       @track.sequence.length_to_delta(@prev_delay))
        @prev_delay = delay
      end
    end
  end
end
