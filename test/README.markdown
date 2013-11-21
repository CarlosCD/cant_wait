# cant_wait ~ development and test
[![Gem Version](https://badge.fury.io/rb/cant_wait.png)](https://badge.fury.io/rb/cant_wait)
[![Dependency Status](https://gemnasium.com/CarlosCD/cant_wait.png)](https://gemnasium.com/CarlosCD/cant_wait)


## Test setup and choices

- Minitest, to keep things simple.
- PostgreSQL database server (localhost or not).
- I used RVM.  This is not a requirement, other ruby version managers should work as well.


## Test strategy: different Rails apps with random timeouts

### The problem

The approach of using minimal Rails components (ActiveRecord, Railties) is problematic due to the amount of code Rails loads and of how it changes Ruby's standard behavior.  I wanted to test it as close as possible to how an end user would use the gem.

To test different versions of Rails, and different timeout scenarios, requires to run several Rails apps either simultaneously or sequentially.  Even using different threads, being a Rails Application a singleton, it will end up in:

    RuntimeError: You cannot have more than one Rails::Application

This path would also make the test cases too distant to the real conditions of an isolated Rails app.  Even if the singleton restriction is removed in the future (see this interesting discussion regarding Rails 4.1: <https://github.com/rails/rails/pull/9655>), it will still apply to older versions of Rails.

### A solution

I finally chose to test several versions of Rails/ActiveRecord independently.

I created 5 simple Rails apps, of different versions, in the folder test/test_apps.

Then I modified their Gemfile by adding gems for PostgreSQL, Minitest and Growl:

    if RUBY_ENGINE == 'jruby' && RUBY_PLATFORM == 'java'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
    else
      gem 'pg', '~> 0'
    end

    if RUBY_PLATFORM =~ /darwin/i
      gem 'minitest-growl', '~> 0.0.3'
      gem 'minitest', '~> 4.7.4'
    else
      gem('minitest', '~> 5') if RUBY_VERSION < '1.9.3'
    end

    gem 'cant_wait', path: File.expand_path('../../../..', __FILE__)

The rails apps require also to run <tt>bundle install</tt> for each app, especially when changing the version of Ruby used.  To make it easier, I added a rake task (<tt>rake test:bundle</tt>).

The actual test is run through the <tt>rake test:run</tt> command.  It goes over each Rails app in sequence and:

1. It sets Bundler to use the test app's Gemfile
2. It creates the app's <tt>config/database.yml</tt> with a random timeout
3. It starts Rails
4. It checks the version of Rails and ActiveRecord running.
5. It checks that the PostgreSQL connection's statement_timeout is the expected.

Due to the complex setup, and to signal the developer to stop and consider these choices, I chose not to use the rake default to run the tests, as it is most common.

An additional task <tt>rake test:all</tt> will do both the <tt>bundle install</tt> and run the tests.  Travis-ci also runs each of these tasks in sequence.


## The Testing process in detail

After cloning the gem, you can start testing it by following these steps:

1. Choose the version of Ruby you want to use.
    For example, if you have a rvm 1.9.3 installed, and a gemset called mygemset:

        rvm use 1.9.3@mygemset

2. Optional: if you are using Mac OS X, get Growl

3. Get the gem's dependencies:

        bundle

4. Set up your PostgreSQL test database and edit accordingly the file <tt>test/database.yml</tt>

5. Get the gems used by the test Rails apps:

        rake test:bundle

6. Your setup is complete.  To run the tests:

        rake test:run

If desired, run the tests several times.  The tests use different random timeout scenarios, so each run may be a bit different.


## Travis

I added travis-ci.org to check every build pushed to Github, and a clickable badge to check the status of the last test.

Check the .travis.yml file for details.


## Tested with

* Versions of Ruby:

        1.9.2-p320          (MRI's last patchlevel of 1.9.2)  Linux and Mac OS X
        1.9.3-p448          (MRI last patchlevel of 1.9.3)    Linux and Mac OS X
        2.0.0-p247          (MRI last patchlevel of 2.0.0)    Linux and Mac OS X
        jruby 1.7.8         (Java 1.6.0)                      Mac OS X
        jruby 1.7.8         (Java 1.7.0)                      Linux
        Rubinius 2.0.0      (1.9.3-compatible)                Linux

  It requires at least MRI 1.9.1 or compatible.

* Versions of Rails:

        Rails 3.0.3      First version using Bundler 1.3.5 (incompatible with Bundler 1.0.X)
        Rails 3.0.20     Last patchlevel of Rails 3.0 (at this moment)
        Rails 3.1.12     Last patchlevel of Rails 3.1
        Rails 3.2.15     Last patchlevel of Rails 3.2
        Rails 4.0.1      Last Release of Rails 4.0

* PostgreSQL versions 8.3.6 and 9.2.4.


## Development / Contributing

If you find any problem, please feel free to open an 'issue' at [GitHub](https://github.com/CarlosCD/cant_wait).

Contributing:

1. Fork it
2. Create your feature branch (<tt>git checkout -b my-new-feature</tt>)
3. Commit your changes (<tt>git commit -am "Add some feature"</tt>)
4. Push to the branch (<tt>git push origin my-new-feature</tt>)
5. Create new Pull Request


November 2013
