# cant_wait
# Development and Test


## Test preferences and setup

- Minitest, to keep things simple.
- PostgreSQL database server (localhost or not).
- I used rvm (not a need if other ruby version manager is preferred). 


## Test strategy: different Rails apps with random timeouts

The approach of using minimal Rails components (ActiveRecord, Railties) is problematic due to the amount of code that Rails loads and of how it changes in the default behavior of Ruby.  Running several Rails apps at the same time, and even if it is done in different threads, may result in:

    RuntimeError: You cannot have more than one Rails::Application

This approach also makes the test cases too distant to the real conditions you may encounter in isolated Rails applications.  I finally choose to test several versions of Rails/ActiveRecord independently.

I created 5 simple Rails apps in the folder test/test_apps.  Then I modified their Gemfile by adding gems for PostgreSQL, Minitest and Growl:

    if RUBY_ENGINE == 'jruby' && RUBY_PLATFORM == 'java'
      gem 'activerecord-jdbc-adapter', '~> 1.2'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
      gem 'jdbc-postgres', '~> 9'
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

The rails apps require bundle install, specially when changing the version of Ruby to be used. To make it easier, I added a rake task (rake test:bundle).

The test is run through the rake test:run command.  Due to the complex setup needed, I choose not to use the rake default to run the test.

The test (rake test:run) goes over each rails app in sequence and:

1. It sets Bundle to use the test app's Gemfile
2. It creates the app's config/database.yml with a random timeout
3. It starts Rails
4. It checks the version of Rails and ActiveRecord running.
5. It checks that the PostgreSQL connection's statement_timeout is the expected.


## The Testing process

After cloning the gem, you can start testing it by following these steps:

1. Choose the version of Ruby you want to use.
    For example, if you have a rvm 1.9.3 installed, and a gemset called mygemset:

        rvm use 1.9.3@mygemset

2. Optional: if you are using Mac OS, get Growl

3. Get the gem's dependencies:

        bundle

4. Set up your PostgreSQL test database and edit accordingly the file test/database.yml

5. Get the Rails gems used by the test rails apps included:

        rake test:bundle

6. You are now done setting all up.  To run the tests:

        rake test:run

If so wanted, run the tests several times.  The tests use different random timeout scenarios, so each run may be a bit different.


## Tested for

* Versions of Ruby:

        jruby 1.7.4
        1.9.2-p320  (MRI's last patchlevel of 1.9.2)
        1.9.3-p429  (MRI last patchlevel of 1.9.3)
        2.0.0-p195  (MRI last patchlevel of 2.0.0)

* Versions of Rails:

        Rails 3.0.3      First version using Bundler 1.3.5 (incompatible with Bundler 1.0.X)
        Rails 3.0.20     Last patchlevel of Rails 3.0 (at this moment)
        Rails 3.1.12     Last patchlevel of Rails 3.1
        Rails 3.2.13     Last patchlevel of Rails 3.2 (many security fixes, last stable version)
        Rails 4.0.0.rc1  Last Release candidate for Rails 4, the most stable version at this point in time.

* PostgreSQL versions 8.3.6 and 9.2.4.


June 2013
