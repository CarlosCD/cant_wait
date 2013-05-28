@gem_spec = eval(File.read(Dir['*.gemspec'].first))

Dir[File.join('tasks', '*.rake')].each do |file_name|
  load file_name
end
