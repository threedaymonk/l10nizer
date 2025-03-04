require "l10nizer/locale_generator"

RSpec.describe L10nizer::LocaleGenerator do
  subject(:locale_generator) { described_class.new }

  it "generates a locale tree for the specified language" do
    input = {
      "aaa.bbb.ccc" => "Ccc",
      "aaa.bbb.ddd" => "Ddd",
      "aaa.eee.fff" => "Fff",
      "ggg.hhh.iii" => "Iii"
    }

    output = {
      "fr" => {
        "aaa" => {
          "bbb" => {"ccc" => "Ccc", "ddd" => "Ddd"},
          "eee" => {"fff" => "Fff"}
        },
        "ggg" => {
          "hhh" => {"iii" => "Iii"}
        }
      }
    }

    expect(locale_generator.call(input, lang: "fr")).to eq(output)
  end
end
