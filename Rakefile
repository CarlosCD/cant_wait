@gem_spec = eval(File.read(Dir['*.gemspec'].first))

Dir[File.join('tasks', '*.rake')].each do |file_name|
  load file_name
end

task :default do
  puts 'No default task defined. Please take a look to test/Readme.md for details.'
  puts 'Here is what you can do:'
  puts
  system 'bundle exec rake -T'
end

private

def boolean_env_param(environment_var, *values)
  ENV[environment_var] && values.include?(ENV[environment_var].strip.downcase)
end
