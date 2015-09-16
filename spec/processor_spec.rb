require 'l10nizer/processor'

RSpec.describe L10nizer::Processor do
  let(:key_generator) {
    lambda { |string|
      string.downcase.gsub(/[^a-z0-9]+/, '_').gsub(/^_|_$/, '')[0, 40]
    }
  }

  subject {
    described_class.new(html, key_generator)
  }

  context 'when finding text' do
    let(:html) { 'just some text' }

    it 'passes key to t()' do
      expect(subject.reformed).to eq(%{<%= t("just_some_text") %>})
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('just_some_text' => 'just some text')
    end
  end

  context 'when interpolating inline eval' do
    let(:html) { 'String <%= 27 %> with <%= 42 %>' }

    it 'passes values to t()' do
      expect(subject.reformed).to eq(%{<%= t("string_a_with_b", a: (27), b: (42)) %>})
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('string_a_with_b' => 'String %{a} with %{b}')
    end
  end

  context 'when interpolating in multiple text strings' do
    let(:html) { '<p>String <%= 27 %> with <%= 42 %></p><p>Another <%= "x" %></p>' }

    it 'passes values to t() reusing placeholder variables' do
      expect(subject.reformed).
        to eq(%{<p><%= t("string_a_with_b", a: (27), b: (42)) %></p><p><%= t("another_a", a: ("x")) %></p>})
    end

    it 'extracts l10n strings with placeholder variables' do
      expect(subject.l10ns).to eq(
        'string_a_with_b' => 'String %{a} with %{b}',
        'another_a' => 'Another %{a}'
      )
    end
  end

  context 'an inline eval on its own' do
    let(:html) { '<p><%= 27 %></p>' }

    it 'is not localised' do
      expect(subject.reformed).to eq(html)
    end
  end

  context 'an HTML comment' do
    let(:html) { '<!-- <p><%= 27 %></p> --> <p> <!-- fooo --> </p>' }

    it 'is not localised' do
      expect(subject.reformed).to eq(html)
    end
  end

  context 'JavaScript' do
    let(:html) { '<script>var a = 3;</script> <script>var b = "b";</script>' }

    it 'is not localised' do
      expect(subject.reformed).to eq(html)
    end
  end

  context 'inline style' do
    let(:html) {
      <<-HTML
        <style type="text/css">
          html.js .nojs {display: none; background:#fff!important;}
        </style>
      HTML
    }

    it 'is not localised' do
      expect(subject.reformed).to eq(html)
    end
  end

  context 'control inside a tag' do
    let(:html) { %{<div class="user-skills block <% unless @user.skills.any? %>blank<% end %>">} }

    it 'is not localised' do
      expect(subject.reformed).to eq(html)
    end
  end

  context 'a string containing inline markup' do
    let(:html) { '<p>String with <strong>strong</strong> and <em>emphasised</em> text</p>' }
    let(:key_generator) { ->(*a) { 'key' } }

    it 'includes that markup in text' do
      expect(subject.l10ns.values).
        to include('String with <strong>strong</strong> and <em>emphasised</em> text')
    end

    it 'uses only one localisation' do
      expect(subject.reformed).to eq(%{<p><%= t("key") %></p>})
    end
  end

  context '<span> within text' do
    let(:html) { %{foo <span>bar</span>} }

    it 'is not treated as inline markup' do
      expect(subject.l10ns.values).to eq(%w[ foo bar ])
    end
  end

  context 'a sample document' do
    let(:html) {
      File.read(File.expand_path('../samples/input.html.erb', __FILE__))
    }

    it 'replaces embedded text' do
      expect(subject.reformed).
        to eq(File.read(File.expand_path('../samples/output.html.erb', __FILE__)))
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('skills' => 'Skills')
    end
  end

  context 'multi-byte characters' do
    let(:html) { '<p>We’ve</p>' }

    it 'includes them in strings' do
      expect(subject.l10ns.values).to include('We’ve')
    end
  end
end
