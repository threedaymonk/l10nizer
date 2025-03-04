require 'l10nizer/namespacer'

RSpec.describe L10nizer::Namespacer do
  subject(:namespacer) { described_class.new }

  it "turns app/views/foo/bar.html.erb into foo.bar" do
    expect(namespacer.call("app/views/foo/bar.html.erb")).to eq("foo.bar")
  end

  it "turns app/views/_foo/bar.html.erb into foo.bar" do
    expect(namespacer.call("app/views/_foo/bar.html.erb")).to eq("foo.bar")
  end
end
