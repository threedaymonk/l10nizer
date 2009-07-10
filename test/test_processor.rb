$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "test/unit"
require "l10nizer/processor"
require "shoulda"

class ProcessorTest < Test::Unit::TestCase

  class DumbKeyGenerator
    def call(string)
      string.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "")[0, 40]
    end
  end

  context "when finding text" do
    setup do
      html = "just some text"
      @l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    end

    should "pass key to t()" do
      expected = %{<%= t("just_some_text") %>}
      assert_equal expected, @l10nizer.reformed
    end

    should "extract l10n strings" do
      expected = {"just_some_text" => "just some text"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

  context "when interpolating inline eval" do
    setup do
      html = "String <%= 27 %> with <%= 42 %>"
      @l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    end

    should "pass values to t()" do
      expected = %{<%= t("string_a_with_b", :a => 27, :b => 42) %>}
      assert_equal expected, @l10nizer.reformed
    end

    should "extract l10n strings" do
      expected = {"string_a_with_b" => "String {{a}} with {{b}}"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

  context "when interpolating in multiple text strings" do
    setup do
      html = "<p>String <%= 27 %> with <%= 42 %></p><p>Another <%= 'x' %></p>"
      @l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    end

    should "pass values to t() reusing placeholder variables" do
      expected = %{<p><%= t("string_a_with_b", :a => 27, :b => 42) %></p><p><%= t("another_a", :a => 'x') %></p>}
      assert_equal expected, @l10nizer.reformed
    end

    should "extract l10n strings with placeholder variables" do
      expected = {"string_a_with_b" => "String {{a}} with {{b}}", "another_a" => "Another {{a}}"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

  context "when inline eval stands on its own" do
    setup do
      @html = "<p><%= 27 %></p>"
      @l10nizer = L10nizer::Processor.new(@html, DumbKeyGenerator.new)
    end

    should "not try to localise it" do
      expected = @html
      assert_equal expected, @l10nizer.reformed
    end
  end

  context "when parsing a sample document" do
    setup do
      @html     = File.read(File.join(File.dirname(__FILE__), "samples", "input.html.erb"))
      @expected = File.read(File.join(File.dirname(__FILE__), "samples", "output.html.erb"))
      @l10nizer = L10nizer::Processor.new(@html, DumbKeyGenerator.new)
    end

    should "replace embedded text" do
      actual = @l10nizer.reformed
      #@expected.split(/\n/).zip(actual.split(/\n/)).each do |a, b|
      #  puts a, b unless a == b
      #end
      assert_equal @expected, actual
    end

    should "extract l10n strings" do
      expected = {"skills" => "Skills"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

end
