# Development and debugging:
#
#  rake debug:build       # Temporarily builds the gem without committing files to git
#  rake debug:try         # Temporarily install the gem without committing files to git

namespace :debug do

  # rake debug:build SLOW=y
  # rake debug:build
  desc 'Temporarily builds the gem without committing files to git'
  # Creates the gem file, without installing it, to try it somewhere else.
  #   It doesn't alter the git repository, even if some things may not have been commited yet
  # Argument (env.):
  #   SLOW=t     Pauses or not in each step.
  #              Other possible values (meaning the same): t, true, y, yes, on, ok
  #              Default: no pause (no flag)
  task :build do
    pausing = boolean_env_param 'SLOW', 't', 'y', 'on', 'ok', 'yes', 'true'
    use_gem_as_it_is @gem_spec, pausing, get_it_back: true
  end

  # rake debug:install SLOW=y
  # rake debug:install
  desc 'Temporarily install the gem without committing files to git'
  # Install the gem as it is, during the development cycle, in order to try it out
  #   It doesn't alter the git repository, even if some things may not have been committed yet
  # Argument (env.):
  #   SLOW=t     Pauses or not in each step.
  #              Other possible values (meaning the same): t, true, y, yes, on, ok
  #              Default: no pause (no flag)
  task :install do
    pausing = boolean_env_param 'SLOW', 't', 'y', 'on', 'ok', 'yes', 'true'
    use_gem_as_it_is @gem_spec, pausing, install_gem: true
  end

  private

  # options = { get_it_back: false, install_gem: false }
  def use_gem_as_it_is(gem_spec, pause=true, options={})

    gem_name = gem_spec.name
    gem_version = gem_spec.version
    gem_pkg_directory = FileUtils.pwd+'/pkg'

    little_step 'Removing previous test files from the /tmp folder', pause do
      FileUtils.rm_rf "/tmp/#{gem_name}"
    end

    little_step 'Copying the gem folder to /tmp...', pause do
      FileUtils.cp_r '.', "/tmp/#{gem_name}"
    end

    little_step "Changing work directory to /tmp/#{gem_name}", pause do
      FileUtils.cd "/tmp/#{gem_name}"
      puts "And now the folder is (pwd): #{FileUtils.pwd}"
    end

    little_step 'Commiting changes to GIT', pause do
      system 'git add .'
      system 'git commit -m "Just testing"'
    end

    # Note: This may have issues with Ruby 2.0.0
    little_step 'Changing permisions in the gem files to make them world-readeable', pause do
      gem_spec.files.each do |file_name|
        FileUtils.chmod(File.stat(file_name).mode | 444, file_name, { verbose: true }) if (File.stat(file_name).mode & 444) != 444
      end
    end

    little_step 'Building the gem', pause do
      system "gem build #{gem_name}.gemspec"
    end

    # Now do something with the new gem:

    if options[:get_it_back]
      little_step 'Copying the gem file to the initial folder', pause do
        FileUtils.mkdir gem_pkg_directory rescue nil
        FileUtils.cp "#{gem_name}-#{gem_version}.gem", gem_pkg_directory
      end
    end

    if options[:install_gem]
      little_step 'Installing the gem locally (rvm-dependent)', pause do
        system "rvm current"
        system "gem install #{gem_name}-#{gem_version}.gem"
      end
    end

    little_step 'Cleaning up temporary files', pause do
      FileUtils.rm_rf "/tmp/#{gem_name}"
    end

  end

  def little_step (message, pause=true)
    puts "#{message}..."
    yield if block_given?
    wait_for_input if pause
    puts '---'
  end

  def wait_for_input(message='Press [enter] to continue')
    puts message
    STDIN.gets
  end

end
