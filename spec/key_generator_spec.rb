require "l10nizer/keygen"

RSpec.describe L10nizer::KeyGenerator do
  context "without namespacing" do
    it "generates keys based on string" do
      expect(subject.call("Foo bar  baz  %{a}")).to eq("foo_bar_baz_a")
    end

    it "truncates exceptionally long keys" do
      long = "blah_" * 20
      short = "blah_blah_blah_blah_blah_blah_blah_blah"
      expect(subject.call(long)).to eq(short)
    end

    it "reuses key for same text" do
      expect(subject.call("the same")).to eq(subject.call("the same"))
    end

    it "prevents duplicate keys for texts that differ by case" do
      expect(subject.call("a thing")).to eq("a_thing")
      expect(subject.call("A thing")).to eq("a_thing_1")
      expect(subject.call("A Thing")).to eq("a_thing_2")
    end

    it "generates non empty keys for punctuation" do
      expect(subject.call("<>!@#%#.,")).not_to be_empty
    end

    it "skips entities in keys" do
      expect(subject.call("foo &apos; bar")).to eq("foo_bar")
    end

    it "skips inline markup in keys" do
      expect(subject.call("foo <strong>bar</strong>")).to eq("foo_bar")
    end
  end

  context "with namespacing" do
    before do
      subject.namespace = "ns1"
    end

    it "prepends namespace" do
      expect(subject.call("Foo")).to eq("ns1.foo")
    end

    it "prevents duplicate keys for different texts" do
      expect(subject.call("a thing")).to eq("ns1.a_thing")
      expect(subject.call("A thing")).to eq("ns1.a_thing_1")
      expect(subject.call("A Thing")).to eq("ns1.a_thing_2")
    end

    it "checks duplication by namespace" do
      expect(subject.call("a thing")).to eq("ns1.a_thing")
      subject.namespace = "ns2"
      expect(subject.call("A thing")).to eq("ns2.a_thing")
    end
  end
end
