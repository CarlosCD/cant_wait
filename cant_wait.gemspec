# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cant_wait/version'

Gem::Specification.new do |spec|
  spec.name          = 'cant_wait'
  spec.version       = CantWait::VERSION
  spec.summary       = %q{Adds statement timeout for PostgreSQL databases in Ruby on Rails. Timeout is measured in milliseconds.}
  spec.description   = <<-EOF
    Adds a timeout setting for PostgreSQL databases in a Ruby on Rails application.
    If any SQL statement takes more time than the timeout value, it will be cancelled, and ActiveRecord
    would raise a PGError exception.
    In the config/database.yml file, indicate a timeout in milliseconds for each environment:
      production:
        adapter: postgresql
        timeout: 120_000  # 2 minutes
        ...
    (see documentation for more details)
  EOF

  spec.license       = 'MIT'

  spec.authors       = ['Carlos A. Carro Duplá']
  spec.email         = ['ccarrodupla@gmail.com']
  spec.homepage      = 'https://github.com/CarlosCD/cant_wait'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0.3'

  spec.signing_key = '/users/CarlosCD/.ssh/private_key.pem'
  spec.cert_chain  = ['/users/CarlosCD/.ssh/public_cert.pem']

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
