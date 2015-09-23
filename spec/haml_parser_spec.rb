require 'l10nizer/haml_parser'

RSpec.describe L10nizer::HamlParser do
  subject {
    described_class.new.parse(source).elements
  }

  context 'with an explicit tag' do
    let(:source) { '%div' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'with an implicit tag' do
    let(:source) { '.foo' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'with a complicated tag' do
    let(:source) { '%div#aaa.foo.bar{ attr: "baz" }' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'with a tag with "terser" attributes' do
    let(:source) { '%html(xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en")' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'with a tag with evaluated content' do
    let(:source) { '%div= 1 + 1' }
    it { is_expected.to have_attributes(length: 2) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: '%div') }
    end

    context 'the second node' do
      subject { super().fetch(1) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Eval) }
      it { is_expected.to have_attributes(text_value: '= 1 + 1') }
    end
  end

  context 'with a tag with text content' do
    let(:source) { '%div text goes here' }
    it { is_expected.to have_attributes(length: 2) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Element) }
      it { is_expected.to have_attributes(text_value: '%div') }
    end

    context 'the second node' do
      subject { super().fetch(1) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Text) }
      it { is_expected.to have_attributes(text_value: 'text goes here') }
    end
  end

  context 'comment' do
    let(:source) { '/ #{foo} text goes here' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'directive' do
    let(:source) { ':javascript\nblah\nblah\n\n' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'text content' do
    let(:source) { 'text goes here' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Text) }
      it { is_expected.to have_attributes(text_value: source) }
    end
  end

  context 'text content with interpolation' do
    let(:source) { '#{foo} and #{bar}' }
    it { is_expected.to have_attributes(length: 1) }

    context 'the first node' do
      subject { super().fetch(0) }
      it { is_expected.to be_kind_of(L10nizer::Haml::Text) }
      it { is_expected.to have_attributes(text_value: source) }

      context 'children' do
        subject { super().children }
        it { is_expected.to have_attributes(length: 3) }

        context 'first' do
          subject { super().fetch(0) }
          it { is_expected.to be_kind_of(L10nizer::Haml::Eval) }
          it { is_expected.to have_attributes(text_value: 'foo') }
        end

        context 'second' do
          subject { super().fetch(1) }
          it { is_expected.to be_kind_of(L10nizer::Haml::Word) }
          it { is_expected.to have_attributes(text_value: ' and ') }
        end

        context 'third' do
          subject { super().fetch(2) }
          it { is_expected.to be_kind_of(L10nizer::Haml::Eval) }
          it { is_expected.to have_attributes(text_value: 'bar') }
        end
      end
    end
  end
end
