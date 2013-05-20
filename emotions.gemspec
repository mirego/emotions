# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emotions/version'

Gem::Specification.new do |spec|
  spec.name          = "emotions"
  spec.version       = Emotions::VERSION
  spec.authors       = ["Rémi Prévost"]
  spec.email         = ["remi@exomel.com"]
  spec.description   = 'Emotions is a Ruby library that allows ActiveRecord records to express (and hopefully stores) emotions about other records.'
  spec.summary       = 'Emotions is a Ruby library that allows ActiveRecord records to express (and hopefully stores) emotions about other records.'
  spec.homepage      = 'https://github.com/remiprev/emotions'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
