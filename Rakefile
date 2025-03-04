require "rspec/core/rake_task"
require "standard/rake"

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end

task default: %i[spec standard]
