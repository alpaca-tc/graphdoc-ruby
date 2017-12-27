
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphdoc-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphdoc-ruby'
  spec.version       = GraphdocRuby::VERSION
  spec.authors       = ['alpaca-tc']
  spec.email         = ['alpaca-tc@alpaca.tc']

  spec.summary       = 'Graphdoc application based on rack'
  spec.description   = 'Graphdoc application based on rack'
  spec.homepage      = 'https://github.com/alpaca-tc/graphdoc-ruby'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.2.0'
  spec.add_dependency 'bundler'
  spec.add_dependency 'rack'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
