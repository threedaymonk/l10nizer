require "rubygems"
require "rake/gempackagetask"
require "rake/testtask"
require "lib/l10nizer/version"

task :default => [:test]

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

spec = Gem::Specification.new do |s|
  s.name              = "l10nizer"
  s.version           = L10nizer::VERSION::STRING
  s.summary           = "Automatically extract strings from ERB templates and replace with calls to t()"
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"

  s.has_rdoc          = false

  s.files             = %w(Rakefile) + Dir.glob("{bin,test,lib}/**/*")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.add_dependency("treetop",  "~> 1.2.6")
  s.add_dependency("polyglot", "~> 0.2.5")

  s.add_development_dependency("thoughtbot-shoulda")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc 'Clear out generated packages'
task :clean => [:clobber_package] do
  rm "#{spec.name}.gemspec"
end
