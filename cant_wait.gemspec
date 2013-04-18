# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'cant_wait/version'

Gem::Specification.new do |spec|
  spec.name          = 'cant_wait'
  spec.version       = CantWait::VERSION
  spec.authors       = ['Carlos A. Carro Duplá']
  spec.email         = ['no_spam@thanks.com']
  spec.description   = <<-EOF
    Adds a timeout setting for PostgreSQL databases in a Ruby on Rails application.
    If any SQL statement takes more time than the timeout value, it will be cancelled, and ActiveRecord
    would raise a PGError exception.
    In the config/database.yml file, indicate a timeout in milliseconds for each environment:
      production:
        adapter: postgresql
        timeout: 120_000  # 2 minutes
        ...
  EOF
  spec.summary       = %q{Adds statement timeout for PostgreSQL databases in Ruby on Rails. Timeout is measured in milliseconds.}
  spec.homepage      = 'https://github.com/CarlosCD'
  spec.license       = 'MIT'

  spec.add_dependency 'rails', '>= 3.0.3'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
