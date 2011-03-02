$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'rubygems'
require "test/unit"
require "l10nizer/keygen"
require "shoulda"

class KeyGeneratorTest < Test::Unit::TestCase

  def setup
    @keygen = L10nizer::KeyGenerator.new
  end

  context "without namespacing" do
    should "generate keys based on string" do
      assert_equal "foo_bar_baz_a", @keygen.call("Foo bar  baz  {{a}}")
    end

    should "truncate exceptionally long keys" do
      long  = "blah_" * 20
      short = "blah_blah_blah_blah_blah_blah_blah_blah"
      assert_equal short, @keygen.call(long)
    end

    should "reuse key for same text" do
      assert_equal @keygen.call("the same"), @keygen.call("the same")
    end

    should "prevent duplicate keys for different texts" do
      assert_equal "a_thing",   @keygen.call("a thing")
      assert_equal "a_thing_1", @keygen.call("A thing")
      assert_equal "a_thing_2", @keygen.call("A Thing")
    end

    should "generate non empty keys for punctuation" do
      assert_not_equal "", @keygen.call("<>!@#%#.,")
    end

    should "skip entities in keys" do
      assert_equal "foo_bar", @keygen.call("foo &apos; bar")
    end

    should "skip inline markup in keys" do
      assert_equal "foo_bar", @keygen.call("foo <strong>bar</strong>")
    end
  end

  context "with namespacing" do
    setup do
      @keygen.namespace = "ns1"
    end

    should "prepend namespace" do
      assert_equal "ns1.foo", @keygen.call("Foo")
    end

    should "prevent duplicate keys for different texts" do
      assert_equal "ns1.a_thing",   @keygen.call("a thing")
      assert_equal "ns1.a_thing_1", @keygen.call("A thing")
      assert_equal "ns1.a_thing_2", @keygen.call("A Thing")
    end

    should "check duplication by namespace" do
      assert_equal "ns1.a_thing", @keygen.call("a thing")
      @keygen.namespace = "ns2"
      assert_equal "ns2.a_thing", @keygen.call("A thing")
    end
  end
end
