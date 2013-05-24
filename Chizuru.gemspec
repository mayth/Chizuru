# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Chizuru/version'

Gem::Specification.new do |spec|
  spec.name          = "Chizuru"
  spec.version       = Chizuru::VERSION
  spec.authors       = ["mayth"]
  spec.email         = ["chimeaquas@hotmail.com"]
  spec.description   = %q{Twitter bot framework}
  spec.summary       = %q{Twitter bot frameowrk}
  spec.homepage      = "https://github.com/mayth/Chizuru"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency 'oauth'
  spec.add_dependency 'yajl-ruby'
end
