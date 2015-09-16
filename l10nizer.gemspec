require "./lib/l10nizer/version"

spec = Gem::Specification.new do |s|
  s.name              = "l10nizer"
  s.version           = L10nizer::VERSION::STRING
  s.summary           = "Automatically extract strings from ERB templates and replace with calls to t()"
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"

  s.has_rdoc          = false

  s.files             = Dir["{bin,lib}/**/*"]
  s.executables       = Dir["bin/**"].map { |f| File.basename(f) }

  s.require_paths     = ["lib"]

  s.add_runtime_dependency "treetop",  ">= 1.2.6"
  s.add_runtime_dependency "polyglot", ">= 0.2.5"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
end
