# Gem building and publication:
#
#  rake gemspec_valid     # Validate the gemspec
#
#  rake build             # Build cant_wait-X.Y.Z.gem into the pkg directory.
#  rake clean             # Clean automatically generated gem files (removes the pkg folder).
#
#  rake install           # Build and install cant_wait-X.Y.Z.gem into system gems.
#
#  rake push              # Push pkg/cant_wait-X.Y.Z.gem to rubygems, if it exists.
#  rake release           # Create tag vX.Y.Z and build and push cant_wait-X.Y.Z.gem to Rubygems

begin
  require 'bundler/gem_tasks'  # Adds these tasks: build, install and release
rescue LoadError
  puts 'You may need Bundler to build this gem.'
end

desc 'Validate the gemspec'
#  It calls the instance method Gem::Specification.validate
#    It checks that the specification contains all required fields, and does a very basic sanity check.
#    It raises InvalidSpecificationException if the spec does not pass the checks...
#      Otherwise outputs nothing
#    See http://rubygems.rubyforge.org/rubygems-update/Gem/Specification.html
task :gemspec_valid do
  @gem_spec.validate
end

desc 'Clean automatically generated gem files (removes the pkg folder).'
task :clean do
  FileUtils.rm_rf 'pkg'
end

desc "Push pkg/#{@gem_spec.name}-#{@gem_spec.version}.gem to rubygems, if it exists."
task :push do
  system "gem push pkg/#{@gem_spec.name}-#{@gem_spec.version}.gem"
end
