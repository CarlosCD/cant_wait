# cant_wait
[![Gem Version](https://badge.fury.io/rb/cant_wait.png)](https://badge.fury.io/rb/cant_wait)
[![Build Status](https://travis-ci.org/CarlosCD/cant_wait.png?branch=master)](https://travis-ci.org/CarlosCD/cant_wait)


This Ruby gem allows to add a statement timeout for PostgreSQL databases within a Ruby on Rails application.

From the PostgreSQL documentation:

>     statement_timeout (integer)
> 
>          Abort any statement that takes more than the specified number of milliseconds, starting
>          from the time the command arrives at the server from the client. If log_min_error_statement
>          is set to ERROR or lower, the statement that timed out will also be logged.  A value of zero
>          (the default) turns this off.
> 
>          Setting statement_timeout in postgresql.conf is not recommended because it would affect all
>          sessions.
> 
>     (© 1996-2013 The PostgreSQL Global Development Group)

(Visit <http://www.postgresql.org/docs/devel/static/runtime-config-client.html> for more information)


If any SQL statement takes more time than the timeout value (measured in milliseconds), its execution will be cancelled, and Active Record would raise a PGError exception.

    ActiveRecord::StatementInvalid: PGError: ERROR:  canceling statement due to statement timeout

If you find any problems, please feel free to open an issue in the gem repository ([GitHub](https://github.com/CarlosCD/cant_wait)).


## Usage

In the file <tt>config/database.yml</tt> of the Rails application, indicate a timeout in milliseconds for each environment:

    production:
      adapter: postgresql
      timeout: 180_000  # 3 minutes
      ...

Then restart the application to establish the new database settings.


## Installation

Add this line to your application's Gemfile:

    gem 'cant_wait', '~> 0.0.3'

And then execute:

    $ bundle


## Dependencies

Previous versions of Rails are not compatible with the last version of bundler, so the minimum requirement is Rails 3.0.3.

The gem has been tested with Rails 3.0.3 and above (including version 4.0.0).  It has also been tested with PostgreSQL versions 8 and 9, but it may work also in other versions supported by Active Record (see PostgreSQL documentation).

### Supported Rubies

**cant_wait** has been tested with the following versions of Ruby:

- 1.9.2
- 1.9.3
- 2.0.0
- jruby
- Rubinius

The gem may work just fine with a Ruby flavors/versions not listed above.

See the development documentation for more details.


## Development / Contributing

* Source hosted on [GitHub](https://github.com/CarlosCD/cant_wait)
* Details on the test setup are in the file README.md within the test folder.  It includes details on testing in several Ruby and Rails versions.

Contributing:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

**cant_wait** is released under the [MIT License](http://opensource.org/licenses/MIT).


June 2013
