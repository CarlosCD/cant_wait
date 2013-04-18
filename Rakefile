begin
  require 'bundler/gem_tasks'
  # Adds the following tasks:
  #   rake build             # Build -0.0.1.gem into the pkg directory.
  #   rake install           # Build and install -0.0.1.gem into system gems.
  #   rake release           # Create tag v0.0.1 and build and push -0.0.1.gem to Rubygems
rescue LoadError
  puts 'You need to have Bundler installed to be able build this gem.'
end

gem_spec = eval(File.read(Dir['*.gemspec'].first))

desc 'Validate the gemspec'
#  It calls the instance method Gem::Specification.validate
#    It checks that the specification contains all required fields, and does a very basic sanity check.
#    It raises InvalidSpecificationException if the spec does not pass the checks...
#      Otherwise outputs nothing
#    See http://rubygems.rubyforge.org/rubygems-update/Gem/Specification.html
task :validate_gemspec do
  gem_spec.validate
end

desc 'Clean automatically generated gem files (removes the pkg folder).'
task :clean do
  FileUtils.rm_rf 'pkg'
end

desc "Push pkg/#{gem_spec.name}-#{gem_spec.version}.gem to rubygems, if it exists."
task :push do
  system "gem push pkg/#{gem_spec.name}-#{gem_spec.version}.gem"
end

# rake dirty_build SLOW=t
# rake dirty_build
desc 'Temporarily builds the gem without committing files to git'
# Creates the gem file, without installing it, to try it somewhere else.
#   It doesn't alter the git repository, even if some things may not have been commited yet
task :dirty_build do
  pausing = (ENV['SLOW'] && ENV['SLOW'].downcase == 't') || false   # Pause or not in each step (no pause by default)
  use_gem_as_it_is gem_spec, pausing, get_it_back: true
end

# rake dirty_try SLOW=t
# rake dirty_try
desc 'Temporarily install the gem without committing files to git'
# Install the gem as it is, during the development cycle, in order to try it out
#   It doesn't alter the git repository, even if some things may not have been committed yet
task :dirty_try do
  pausing = (ENV['SLOW'] && ENV['SLOW'].downcase == 't') || false   # Pause or not in each step (no pause by default)
  use_gem_as_it_is gem_spec, pausing, install_gem: true
end

private

# options = { get_it_back: false, install_gem: false }
def use_gem_as_it_is(gem_spec, pause=true, options={})

  gem_name = gem_spec.name
  gem_version = gem_spec.version
  new_gem_directory = FileUtils.pwd

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
      FileUtils.cp "#{gem_name}-#{gem_version}.gem", new_gem_directory
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
