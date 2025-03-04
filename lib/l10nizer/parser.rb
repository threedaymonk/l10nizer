require "treetop"
require "polyglot"
require "l10nizer/grammar"

module HtmlErb
  class Document < Treetop::Runtime::SyntaxNode
  end

  class Text < Treetop::Runtime::SyntaxNode
    def children
      elements.flat_map(&:elements)
    end
  end

  class Eval < Treetop::Runtime::SyntaxNode
  end

  class Word < Treetop::Runtime::SyntaxNode
  end
end
