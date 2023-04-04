@gem_spec = eval(File.read(Dir['*.gemspec'].first))

Dir[File.join('tasks', '*.rake')].each do |file_name|
  load file_name
end

task :default do
  puts 'It is assumed that the test environment is ready...'
  puts 'If needed, please review test/README.md for details about the testing set up.'
  Rake::Task['test:run'].invoke
end

private

def boolean_env_param(environment_var, *values)
  ENV[environment_var] && values.include?(ENV[environment_var].strip.downcase)
end
