## 1.1.1 (November 24, 2013)

Documentation:

  - Tiny documentation change (Code Climate badge).

## 1.1.0 (November 24, 2013)

Features:

  - Support for PostGIS databases.  Thanks to [Kimitake Miyashita](https://github.com/kimiyash).

## 1.0.1 (November 21, 2013)

Documentation:

  - Tiny documentation change.

## 1.0.0 (November 20, 2013)

Documentation:

  - Bumped the version to 1.0.0, to signal that it is ready for production.  It was actually ready since version 0.0.1, so this change is just to avoid a possible confusion.

Development:

  - Minor tweaks in the test code.
  - Tests for Rails 3.2.15 and 4.0.1
  - Set up of the default rake test to run all the tests, without preparing the data (equivalent to <tt>rake test:run</tt>)
  - Changes in Travis-CI configuration, discontinuing support for Rubinius, while bugs in its interpreter get sorted out.

## 0.0.4 (August 15, 2013)

Features:

  - Encoding UTF-8 (ruby 1.9)

Documentation:

  - Changes in the documentation
  - Minimum ruby is MRI 1.9.1 or compatible
  - Added a 'runtime dependencies' security advisory service.  A dynamic badge on the README files
  - Added the code signing certificate, for gem signature verification

Development:

  - Streamlining PostgreSQL JDBC dependencies for JRuby
  - Minor tweaks in the tests
  - Tested with new patches of MRI for C Ruby 1.9.3 and 2.0.0
  - Tests for Rails 3.2.14

## 0.0.3 (June 26, 2013)

Documentation:

  - Some minor changes in the documentation

Development:

  - Travis scripts stability fixes
  - Tests for Rails 4.0.0

## 0.0.2 (June 15, 2013)

Documentation:

  - Minor changes in the documentation

Development:

  - Integration with travis-ci.org
  - Added tests for Rails 4.0.0.rc2
  - Minor code refactoring (no changes in functionality)
  - Added a new rake task to run <tt>test:bundle</tt> and <tt>test:run</tt> in one pass
