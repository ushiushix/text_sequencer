# -*- encoding: utf-8 -*-
require File.expand_path('../lib/text_sequencer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Koichi Inoue"]
  gem.email         = ["ushiushix@gmail.com"]
  gem.description   = %q{creates MIDI files from a simple text notation.}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "text_sequencer"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "midilib", ">= 2.0.0"
  gem.add_development_dependency "rspec", ">= 2.10"
  gem.version       = TextSequencer::VERSION
end
