require "./lib/l10nizer/version"

Gem::Specification.new do |s|
  s.name = "l10nizer"
  s.version = L10nizer::VERSION::STRING
  s.summary = "Automatically extract strings from ERB templates and replace with calls to t()"
  s.author = "Paul Battley"
  s.email = "pbattley@gmail.com"

  s.files = Dir["{bin,lib}/**/*"]
  s.executables = Dir["bin/**"].map { |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_runtime_dependency "treetop", "~> 1.6"
  s.add_runtime_dependency "polyglot", "~> 0.3.5"

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "standard"
end
