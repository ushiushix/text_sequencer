require 'bundler/setup'
require 'text_sequencer'
require 'text_sequencer/midilib'

s = File.open(ARGV[0]).read
parser = TextSequencer::parse(s)

include MIDI
seq = Sequence.new()
track = Track.new(seq)
seq.tracks << track
track.events << Tempo.new(Tempo.bpm_to_mpq(120))
track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

track = Track.new(seq)
seq.tracks << track

# Give the track a name and an instrument name (optional).
track.name = 'My New Track'
track.instrument = GM_PATCH_NAMES[0]

# Add a volume controller event (optional).
track.events << Controller.new(0, CC_VOLUME, 127)

track.events << ProgramChange.new(0, 1, 0)

# Have text_sequencer export its data to the track
exporter = TextSequencer::MidilibExporter.new(track)
parser.export(exporter)
File.open('example.mid', 'wb') { | file |
  seq.write(file)
}
