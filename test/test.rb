$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "l10nizer"

samples = [
  "foo",
  "<bar>",
  File.read(File.join(File.dirname(__FILE__), "samples", "minimal.html.erb")),
  File.read(File.join(File.dirname(__FILE__), "samples", "simple.html.erb")),
#  File.read(File.join(File.dirname(__FILE__), "samples", "_event.html.erb")),
]

samples.each do |s|
  puts s
  parsed = HtmlErbParser.new.parse(s)
  #puts parsed.interpret
  puts parsed.elements.map{ |e| e.to_s }.join
  p parsed.elements.map{ |e| e.l10n }.compact
  puts
end
