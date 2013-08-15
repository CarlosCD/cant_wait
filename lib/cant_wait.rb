# encoding: utf-8

begin
  require 'cant_wait/version'
  require 'cant_wait/cant_wait_railtie' if defined? Rails
rescue LoadError
  puts 'Some needed files are not accessible to the cant_wait gem, please check its integrity.'
end
