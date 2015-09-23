require 'l10nizer/processor'

RSpec.describe L10nizer::Processor do
  let(:key_generator) {
    lambda { |string|
      string.downcase.gsub(/[^a-z0-9]+/, '_').gsub(/^_|_$/, '')[0, 40]
    }
  }

  subject {
    described_class.new(haml, key_generator, L10nizer::Haml)
  }

  context 'when finding text' do
    let(:haml) { 'just some text' }

    it 'passes key to t()' do
      expect(subject.reformed).to eq(%{= t("just_some_text")})
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('just_some_text' => 'just some text')
    end
  end

  context 'a tag with text' do
    let(:haml) { '%p just some text' }

    it 'passes key to t()' do
      expect(subject.reformed).to eq(%{%p= t("just_some_text")})
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('just_some_text' => 'just some text')
    end
  end

  context 'an inline eval on its own' do
    let(:haml) { '%p= 27' }

    it 'is not localised' do
      expect(subject.reformed).to eq(haml)
    end
  end

  context 'interpolation via #{}' do
    let(:haml) { '%p #{x}, #{y}' }

    it 'is localised as a string' do
      expect(subject.reformed).to eq('%p= t("a_b", a: (x), b: (y))')
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('a_b' => '%{a}, %{b}')
    end
  end

  context 'a sample document' do
    let(:haml) {
      File.read(File.expand_path('../samples/input.html.haml', __FILE__))
    }

    it 'replaces embedded text' do
      expect(subject.reformed).
        to eq(File.read(File.expand_path('../samples/output.html.haml', __FILE__)))
    end

    it 'extracts l10n strings' do
      expect(subject.l10ns).to eq('skills' => 'Skills')
    end
  end

  context 'multi-byte characters' do
    let(:haml) { '%p We’ve' }

    it 'includes them in strings' do
      expect(subject.l10ns.values).to include('We’ve')
    end
  end
end
