# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cant_wait/version'

Gem::Specification.new do |spec|
  spec.name                  = 'cant_wait'
  spec.version               = CantWait::VERSION
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9.1'

  spec.summary       = 'Complements the Ruby on Rails web application framework by providing statement timeouts for PostgreSQL databases.'
  spec.description   = 'Provides statement timeouts for PostgreSQL databases in a Ruby on Rails web application. Stops any SQL statement ' <<
                       'that takes more than a specified number of milliseconds.'

  spec.license       = 'MIT'

  spec.author        = 'Carlos A. Carro Duplá'
  spec.email         = 'ccarrodupla@gmail.com'
  spec.homepage      = 'https://github.com/CarlosCD/cant_wait'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0.3'

  if $0 =~ /gem\z/
    spec.cert_chain  = ['/users/CarlosCD/.ssh/public_cert.pem']
    spec.signing_key = '/users/CarlosCD/.ssh/private_key.pem'
  end

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  if RUBY_ENGINE == 'jruby' && RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'activerecord-jdbc-adapter', '~> 1.2'
    spec.add_development_dependency 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
    spec.add_development_dependency 'jdbc-postgres', '~> 9'
  else
    spec.add_development_dependency 'pg', '~> 0'
  end
  if RUBY_PLATFORM =~ /darwin/i
    spec.add_development_dependency 'minitest-growl', '~> 0.0.3'
    # minitest-growl small problem with minitest 5:
    spec.add_development_dependency('minitest', '~> 4.7.4')
  else
    spec.add_development_dependency('minitest', '~> 5') if RUBY_VERSION < '1.9.3'
  end
end
