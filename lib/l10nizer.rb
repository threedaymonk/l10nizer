require "l10nizer/parser"

module L10nizer
  class Document
    def initialize(html)
      @html = html
    end

    def parsed
      @parsed ||= HtmlErbParser.new.parse(@html)
    end

    def elements
      parsed.elements.map{ |element|

      }
    end
  end

  class TextElement
    def initialize(node)
    end
  end

  class BoringElement
    def initialize(node)
    end

    def to_s
      node.text_value
    end
  end
end


