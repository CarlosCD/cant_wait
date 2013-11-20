# Invocation from tasks/testing.rake:
#   bundle exec ruby test/cant_wait_test.rb #{num} #{@gem_spec.version} #{'V' if verbose}
#   Where the parameters are:
#     1: Number from 0 to 4. Index of the rails app (see TEST_RAILS_APP)
#     2: String with the Gem version, for example '1.0.0'.
#     3: V, for verbose (optional)
# Examples:
#   bundle exec ruby test/cant_wait_test.rb 2 1.0.0
#   bundle exec ruby test/cant_wait_test.rb 4 0.0.4 V

require 'minitest/autorun'
require 'minitest/growl_notify' if RUBY_PLATFORM =~ /darwin/i

ENV['RAILS_ENV'] = 'test'
$LOAD_PATH.unshift(File.dirname(__FILE__))  # We require the rails environment from here

class CantWaitTest < MiniTest::Unit::TestCase

  TEST_RAILS_APP = [{ version: '3.0.3',  rails_root: 'test_apps/Test_3_0_03'},
                    { version: '3.0.20', rails_root: 'test_apps/Test_3_0_20'},
                    { version: '3.1.12', rails_root: 'test_apps/Test_3_1_12'},
                    { version: '3.2.14', rails_root: 'test_apps/Test_3_2_14'},
                    { version: '4.0.0',  rails_root: 'test_apps/Test_4_0_0' }]

  # Sets a random timeout and a Rails app to be tested
  def setup
    # Arguments:
    # To be run from rake test, passing valid args:
    raise 'Wrong number of arguments for test' unless (2..3).include? ARGV.length
    rails_app_index = ARGV[0].to_i # Rails app index passed as an argument:
    @gem_version = ARGV[1]  # '0.0.1' or whatever
    @verbose = ARGV[2] == 'V'

    # If app value given is not valid, we choose a random one:
    valid_range = (0..(TEST_RAILS_APP.length-1))
    rails_app_index = valid_range.include?(rails_app_index) ? rails_app_index : random_number(valid_range)
    @rails_app ||= TEST_RAILS_APP[rails_app_index]
    puts "Rails version aimed at: #{@rails_app[:version]}" if @verbose

    raise 'At least Ruby 1.9.3 is required for rails 4 or above' if (@rails_app[:version] >= '4') && (RUBY_VERSION < '1.9.3')

    # Choose timeout option:
    test_chosen = random_number (1..4)
    case test_chosen
      when 1 then
        # No timeout set:
        @timeout = nil  # Not the same as zero
        @expected_result = 0
        puts 'No timeout set'
      when 2 then
        # Timeout fixed at 5 minutes:
        @timeout = 300_000  # 60x5 = 300 => 300,000 milliseconds
        puts "Timeout set at 5 minutes (#{@timeout} milliseconds)"
        @expected_result = @timeout
      when 3, 4 then  # Giving more chances to this option
        # Random timeout (1 sec to 1 hour)
        @timeout = random_number ((1_000)..(3_600_000))
        puts "Random timeout (from 1 second to 1 hour): #{@timeout} millisec ~> #{@timeout/1_000} sec ~> #{@timeout/60_000} min"
        @expected_result = @timeout
    end
  end

  def test_in_rails_app
    # 1. Create config/database.yml with the given timeout:
    build_database_yml

    # 2. Load Rails app:
    require "#{@rails_app[:rails_root]}/config/environment.rb"

    # 3. Misc. safety checks:

    # Checking Rails and ActiveRecord's versions:
    assert_equal @rails_app[:version], Rails.version, "Rails.version should be #{@rails_app[:version]}, and it is #{Rails.version}"
    assert_equal @rails_app[:version], Rails::VERSION::STRING, "Rails being loaded, Rails::VERSION::STRING should be #{@rails_app[:version]}, and it is #{Rails::VERSION::STRING}"
    puts "Version of Rails loaded (Rails.version): #{Rails.version}" if @verbose
    if @rails_app[:version] == '3.0.3'
      # Strangely, ActiveRecord 3.0.3's VERSION is set to '3.0.1'
      assert_equal '3.0.1', ActiveRecord::VERSION::STRING,  "ActiveRecord being used should be 3.0.1, and it is #{ActiveRecord::VERSION::STRING}"
    else
      assert_equal @rails_app[:version], ActiveRecord::VERSION::STRING,  "ActiveRecord being used should be #{@rails_app[:version]}, and it is #{ActiveRecord::VERSION::STRING}"
    end

    # Are we testing the right version on cant_wait?
    puts "ENV['BUNDLE_GEMFILE'] = '#{ENV['BUNDLE_GEMFILE']}" if @verbose  # Gemfile used by Bundler
    assert_equal CantWait::VERSION, @gem_version, "cant_wait should be #{@gem_version}, and it is #{CantWait::VERSION}"

    # 4. Test that the timeout is the expected
    assert_equal @expected_result, statement_timeout
  end

  private

  def random_number(collection)
    collection.to_a.sample if collection.respond_to? :to_a
  end

  def build_database_yml
    write_database_yml database_yml_contents
  end

  def database_yml_contents
    database_file = File.join(File.dirname(__FILE__), '/database.yml')
    if File.exist?(database_file)
      File.read(database_file)
    else
      <<-DATABASE_SETTINGS
test:
  adapter: postgresql
  host: localhost
  database: test
  username: tester
  password: secret
DATABASE_SETTINGS
    end
  end

  def write_database_yml(content = '')
    database_file = File.join(File.dirname(__FILE__), @rails_app[:rails_root]+'/config/database.yml')
    File.open(database_file, 'w') do |f| 
      f << content.to_s
      f.write("  timeout: #{@timeout}\n") if @timeout
    end
  end

  def statement_timeout
    statement_timeout_string = ActiveRecord::Base.connection.select_all('show statement_timeout')[0]['statement_timeout']
    decifer_postgres_fancy_timeout statement_timeout_string
  end

  def decifer_postgres_fancy_timeout(fancy_timeout='0')
    case fancy_timeout
    when fancy_timeout.to_i.to_s then fancy_timeout.to_i
    when /^(\d+)ms$/ then $1.to_i
    when /^(\d+)s$/ then $1.to_i*1_000
    when /^(\d+)min$/ then $1.to_i*60_000
    when /^(\d+)h$/ then $1.to_i*60*60_000
    when /^(\d+)d$/ then $1.to_i*24*60*60_000
    else
      puts "  fancy_timeout=#{fancy_timeout}"
      0
    end
  end

end
