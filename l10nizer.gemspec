# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{l10nizer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Battley"]
  s.date = %q{2009-07-10}
  s.default_executable = %q{l10nizer}
  s.email = %q{pbattley@gmail.com}
  s.executables = ["l10nizer"]
  s.files = ["Rakefile", "bin/l10nizer", "test/samples", "test/samples/input.html.erb", "test/samples/output.html.erb", "test/test_key_generator.rb", "test/test_l10nizer.rb", "test/test_processor.rb", "lib/l10nizer", "lib/l10nizer/grammar.treetop", "lib/l10nizer/keygen.rb", "lib/l10nizer/node.rb", "lib/l10nizer/parser.rb", "lib/l10nizer/processor.rb", "lib/l10nizer/version.rb", "lib/l10nizer.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Automatically extract strings from ERB templates and replace with calls to t()}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<treetop>, ["~> 1.2.6"])
      s.add_runtime_dependency(%q<polyglot>, ["~> 0.2.5"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<treetop>, ["~> 1.2.6"])
      s.add_dependency(%q<polyglot>, ["~> 0.2.5"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<treetop>, ["~> 1.2.6"])
    s.add_dependency(%q<polyglot>, ["~> 0.2.5"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end
