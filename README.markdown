# cant_wait
[![Gem Version](https://badge.fury.io/rb/cant_wait.png)](https://badge.fury.io/rb/cant_wait)
[![Dependency Status](https://gemnasium.com/CarlosCD/cant_wait.png)](https://gemnasium.com/CarlosCD/cant_wait)
[![Build Status](https://travis-ci.org/CarlosCD/cant_wait.png?branch=master)](https://travis-ci.org/CarlosCD/cant_wait)


This Ruby gem adds statement timeouts for PostgreSQL and PostGIS databases within a Ruby on Rails web application.

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


If any SQL statement takes more time than the timeout value (measured in milliseconds), its execution will be cancelled, and Active Record would raise an exception.

    ActiveRecord::StatementInvalid: PGError: ERROR:  canceling statement due to statement timeout


## Installation

Add this line to your application's Gemfile:

    gem 'cant_wait', '~> 1.1.0'

And then execute:

    bundle


## Usage

In the file <tt>config/database.yml</tt> of the Rails application, indicate a timeout in milliseconds for each environment:

    production:
      adapter: postgresql
      timeout: 180_000  # 3 minutes
      ...

or, in the case of PostGIS:

    production:
      adapter: postgis
      timeout: 180_000  # 3 minutes
      ...

Then restart the application to establish the new database settings.


## Dependencies

The minimum requirement is Rails 3.0.3 and ruby.  The gem has been tested with Rails 3.0.3 and above (including versions 4.0.0 and 4.0.1).  Previous versions of Rails are not compatible with the present version of bundler.

The minimum version of ruby is MRI 1.9.1 or compatible, as the gem uses 1.9 syntax.

It has also been tested with PostgreSQL versions 8 and 9, but it may work also in other versions supported by Active Record (see PostgreSQL documentation).

It has also been tested using PostGIS 2.1, but other versions supported by the activerecord-postgis-adapter should work as well.


### Supported Rubies

**cant_wait** has been tested with the following versions of Ruby:

- 1.9.2
- 1.9.3
- 2.0.0
- jruby

The gem may work fine with other Ruby flavors/versions not listed above.

See the development documentation below for more details.


## Signature

All the versions of **cant_wait** released from rubygems.org have been digitally signed.

To verify that the gem has not been tampered with, I am providing the certificate used in its repository, at [Github](https://github.com/CarlosCD/cant_wait).


## Development

If you find any problem, please feel free to open an issue at the gem's repository ([GitHub](https://github.com/CarlosCD/cant_wait)).

These files could be of particular interest:

+ [The change log](https://github.com/CarlosCD/cant_wait/blob/master/CHANGELOG.markdown)
+ [Test setup details](https://github.com/CarlosCD/cant_wait/blob/master/test/README.markdown)
+ [Gem signature verification](https://github.com/CarlosCD/cant_wait/blob/master/cert/README.markdown)


## License

**cant_wait** is released under the [MIT License](http://opensource.org/licenses/MIT).


November 2013
