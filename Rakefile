require "rake/testtask"

Rake::TestTask.new("test") do |t|
  t.libs   << "test"
  t.pattern = "test/**/test_*.rb"
  t.verbose = true
end

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end
