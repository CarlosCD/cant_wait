# cant_wait ~ development and test
[![Gem Version](https://badge.fury.io/rb/cant_wait.png)](https://badge.fury.io/rb/cant_wait)


## Test setup and choices

- Minitest, to keep things simple.
- PostgreSQL database server (localhost or not).
- I used rvm (not a need if other ruby version manager is preferred). 


## Test strategy: different Rails apps with random timeouts

### The problem

The approach of using minimal Rails components (ActiveRecord, Railties) is problematic due to the amount of code that Rails loads and of how it changes in the default Ruby behavior.  I opted here to test the same way an end user would use the gem.

To test in different Rails versions requires running several Rails Apps either simultaneously or sequentially.  Even if it is done in different threads, being a Rails App a singleton, it will result in:

    RuntimeError: You cannot have more than one Rails::Application

This path also would make the test cases too distant to the real conditions you may encounter in isolated Rails applications, and even if the singleton restriction is removed, it will still apply to old versions of Rails.

### A solution

I finally chose to test several versions of Rails/ActiveRecord independently.

I created 5 simple Rails apps, of different versions, in the folder test/test_apps.

Then I modified their Gemfile by adding gems for PostgreSQL, Minitest and Growl:

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

The rails apps require bundle install, specially when changing the version of Ruby to be used. To make it easier, I added a rake task (<tt>rake test:bundle<tt />).

The test is run through the <tt>rake test:run command<tt />.  The test goes over each rails app in sequence and:

1. It sets Bundle to use the test app's Gemfile
2. It creates the app's <tt>config/database.yml<tt /> with a random timeout
3. It starts Rails
4. It checks the version of Rails and ActiveRecord running.
5. It checks that the PostgreSQL connection's statement_timeout is the expected.

Due to the complex setup needed, I choose not to use the rake default to run the test, just to signal the tester to stop to consider these choices.

And additional <tt>rake test:all<tt /> will do both the bundle install and run the tests. This is the way travis-ci is set to run.


## The Testing process in detail

After cloning the gem, you can start testing it by following these steps:

1. Choose the version of Ruby you want to use.
    For example, if you have a rvm 1.9.3 installed, and a gemset called mygemset:

        rvm use 1.9.3@mygemset

2. Optional: if you are using Mac OS X, get Growl

3. Get the gem's dependencies:

        bundle

4. Set up your PostgreSQL test database and edit accordingly the file <tt>test/database.yml<tt />

5. Get the Rails gems used by the test rails apps included:

        rake test:bundle

6. You are now done setting all up.  To run the tests:

        rake test:run

If so wanted, run the tests several times.  The tests use different random timeout scenarios, so each run may be a bit different.

## Travis

I added travis-ci.org to check every build, as well as a badge to check the status last commit.

Check the .travis.yml file for details.


## Tested with

* Versions of Ruby:

        1.9.2-p320       (MRI's last patchlevel of 1.9.2)  Linux and MacOS X
        1.9.3-p327       (MRI)                             Linux
        1.9.3-p429       (MRI last patchlevel of 1.9.3)    MacOS X
        2.0.0-p0         (MRI)                             Linux
        2.0.0-p195       (MRI last patchlevel of 2.0.0)    MacOS X
        jruby 1.7.3      (java 1.7.0_15)                   Linux
        jruby 1.7.4      (java 1.6.0_45)                   MacOS X
        Rubinius 2.0.0   (1.9.3, 2013-06-12 JI)            Linux

* Versions of Rails:

        Rails 3.0.3      First version using Bundler 1.3.5 (incompatible with Bundler 1.0.X)
        Rails 3.0.20     Last patchlevel of Rails 3.0 (at this moment)
        Rails 3.1.12     Last patchlevel of Rails 3.1
        Rails 3.2.13     Last patchlevel of Rails 3.2 (many security fixes, last stable version)
        Rails 4.0.0.rc2  Last Release candidate for Rails 4, the most stable at this point in time.

  **Note:** in the case of versions of Rails not final yet, <tt>rake test:bundle<tt /> may complain.  In those cases you may need to manually install the gems before running the tests.  For example:

        $ gem install rails --version 4.0.0.rc2 --no-ri --no-rdoc
        $ gem install sass-rails -v 4.0.0.rc2
        ...

* PostgreSQL versions 8.3.6 and 9.2.4.


June 2013
