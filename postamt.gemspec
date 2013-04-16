# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postamt/version'

Gem::Specification.new do |spec|
  spec.name          = "postamt"
  spec.version       = Postamt::VERSION
  spec.authors       = ["Martin Schürrer", "Martin Kavalar"]
  spec.email         = ["martin@schuerrer.org", "martin@sauspiel.de"]
  spec.description   = %q{Choose per model and/or controller&action whether a read-only query should be sent to master or a hot standby. Or just use Postamt.on(:slave) { ... }. }
  spec.summary       = %q{Performs (some of) your read-only queries on a hot standby}
  spec.homepage      = "https://github.com/sauspiel/postamt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject { |f| f.start_with? 'testapp' }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thread_safe", "~> 0.1"
  spec.add_dependency "railties", [">= 3.2.0", "< 4.1.0"]
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
