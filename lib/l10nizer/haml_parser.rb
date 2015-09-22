require 'treetop'
require 'polyglot'
require 'l10nizer/haml_grammar'

module Haml
  class Document < Treetop::Runtime::SyntaxNode
  end

  class Element < Treetop::Runtime::SyntaxNode
    def text_value
      super.sub(/ $/, '')
    end
  end

  class Control < Treetop::Runtime::SyntaxNode
  end

  class Tag < Treetop::Runtime::SyntaxNode
  end

  class CSSClass < Treetop::Runtime::SyntaxNode
  end

  class ElementID < Treetop::Runtime::SyntaxNode
  end

  class Attributes < Treetop::Runtime::SyntaxNode
  end

  class Text < Treetop::Runtime::SyntaxNode
    def children
      elements
    end
  end

  class Eval < Treetop::Runtime::SyntaxNode
  end

  class Word < Treetop::Runtime::SyntaxNode
  end

  class Emitter
    def interpolate(s)
      %{= #{s}}
    end
  end

  Parser = HamlParser
end
