# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'cant_wait/version'

Gem::Specification.new do |spec|
  spec.name          = 'cant_wait'
  spec.version       = CantWait::VERSION
  spec.authors       = ['Carlos A. Carro Duplá']
  spec.email         = ['no_spam@thanks.com']
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Write a gem summary}
  spec.homepage      = 'https://github.com/CarlosCD'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3.5'
  spec.add_development_dependency 'rake', '~> 10.0.4'
end
