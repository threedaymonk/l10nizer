# coding: UTF-8
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
      expected = %{<%= t("string_a_with_b", a: (27), b: (42)) %>}
      assert_equal expected, @l10nizer.reformed
    end

    should "extract l10n strings" do
      expected = {"string_a_with_b" => "String %{a} with %{b}"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

  context "when interpolating in multiple text strings" do
    setup do
      html = "<p>String <%= 27 %> with <%= 42 %></p><p>Another <%= 'x' %></p>"
      @l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    end

    should "pass values to t() reusing placeholder variables" do
      expected = %{<p><%= t("string_a_with_b", a: (27), b: (42)) %></p><p><%= t("another_a", a: ('x')) %></p>}
      assert_equal expected, @l10nizer.reformed
    end

    should "extract l10n strings with placeholder variables" do
      expected = {"string_a_with_b" => "String %{a} with %{b}", "another_a" => "Another %{a}"}
      assert_equal expected, @l10nizer.l10ns
    end
  end

  should "not try to localise inline eval on its own" do
    html = "<p><%= 27 %></p>"
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal html, l10nizer.reformed
  end

  should "not try to localise an HTML comment" do
    html = "<!-- <p><%= 27 %></p> --> <p> <!-- fooo --> </p>"
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal html, l10nizer.reformed
  end

  should "not try to localise Javascript" do
    html = "<script>var a = 3;</script> <script>var b = 'b';</script>"
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal html, l10nizer.reformed
  end

  should "not try to localise inline styles" do
    html = %{<style type="text/css">\nhtml.js .nojs {display: none; background:#fff!important;}\n</style>}
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal html, l10nizer.reformed
  end

  should "not try to localise control inside a tag" do
    html = %{<div class="user-skills block <% unless @user.skills.any? %>blank<% end %>">}
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal html, l10nizer.reformed
  end

  context "when string contains inline markup" do
    setup do
      html = "<p>String with <strong>strong</strong> and <em>emphasised</em> text</p>"
      @l10nizer = L10nizer::Processor.new(html, lambda{ |*a| "key" })
    end

    should "include that markup in text" do
      expected = "String with <strong>strong</strong> and <em>emphasised</em> text"
      assert_equal [expected], @l10nizer.l10ns.values
    end

    should "use only one localisation" do
      expected = %{<p><%= t("key") %></p>}
      assert_equal expected, @l10nizer.reformed
    end
  end

  should "not consider <span> to be inline markup" do
    html = %{foo <span>bar</span>}
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal ["bar", "foo"], l10nizer.l10ns.values.sort
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

  should "parse multi-byte characters in strings" do
    html = "<p>We’ve</p>"
    l10nizer = L10nizer::Processor.new(html, DumbKeyGenerator.new)
    assert_equal ["We’ve"], l10nizer.l10ns.values
  end
end
