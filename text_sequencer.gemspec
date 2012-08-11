# -*- encoding: utf-8 -*-
require File.expand_path('../lib/text_sequencer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Koichi Inoue"]
  gem.email         = ["ushiushix@gmail.com"]
  gem.description   = %q{Parse dedicated text notation to generate MIDI data..}
  gem.summary       = %q{
text_sequencer parses simple text notation of musical score and allows you to generate sound files. Currently it supports using midilib to export MIDI data.
}
  gem.homepage      = "http://github.com/ushiushix/text_sequencer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "text_sequencer"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "midilib", ">= 2.0.0"
  gem.add_development_dependency "rspec", ">= 2.10"
  gem.version       = TextSequencer::VERSION
end
