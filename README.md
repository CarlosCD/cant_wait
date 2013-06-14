# cant_wait

This ruby gem allows to add a statement timeout for PostgreSQL databases within a Ruby on Rails application.

If any SQL statement takes more time than the timeout value (measured in milliseconds), its execution will be cancelled, and Active Record
would raise a PGError exception.

    ActiveRecord::StatementInvalid: PGError: ERROR:  canceling statement due to statement timeout

From the PostgreSQL documentation:

>     statement_timeout (integer)
> 
>          Abort any statement that takes more than the specified number of milliseconds, starting from the time the command arrives at the server from the client. If log_min_error_statement is set to ERROR or lower, the statement that timed out will also be logged.  A value of zero (the default) turns this off.
> 
>          Setting statement_timeout in postgresql.conf is not recommended because it would affect all sessions.
> 
>     (© 1996-2013 The PostgreSQL Global Development Group)

(Visit <http://www.postgresql.org/docs/devel/static/runtime-config-client.html> for more information)


The gem has been tested for ruby 1.9.2 and above, as well as with Rails 3.0.3 and above.  Tested also with PostgreSQL 8 and 9, but it may work also in other versions supported by Active Record (see PostgreSQL documentation).

If you find any problems, please feel free to open any issues within the gem repository ([GitHub](https://github.com/CarlosCD/cant_wait)).


## Installation

Add this line to your application's Gemfile:

    gem 'cant_wait', '~> 0.0.2'

And then execute:

    $ bundle


## Usage

In the file config/database.yml, indicate a timeout in milliseconds for each environment:

    production:
      adapter: postgresql
      timeout: 120_000  # 2 minutes
      ...

Then restart the application to establish the new configuration parameter(s).


## Development / Contributing

* Source hosted on [GitHub](https://github.com/CarlosCD/cant_wait)
* Details on the test setup are in the file Readme.md within the test folder. It includes details on testing in several Ruby and Rails versions.

Contributing:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


May 2013
