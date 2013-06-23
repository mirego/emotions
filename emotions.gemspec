# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emotions/version'

Gem::Specification.new do |spec|
  spec.name          = 'emotions'
  spec.version       = Emotions::VERSION
  spec.authors       = ['Rémi Prévost']
  spec.email         = ['rprevost@mirego.com']
  spec.description   = 'Emotions is a Ruby library that allows ActiveRecord records to express (and hopefully store) emotions about other records.'
  spec.summary       = 'Emotions is a Ruby library that allows ActiveRecord records to express (and hopefully store) emotions about other records.'
  spec.homepage      = 'https://github.com/mirego/emotions'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency 'database_cleaner', '~> 1.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
