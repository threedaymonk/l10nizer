require "treetop"
require "polyglot"
require "l10nizer/grammar"

module HtmlErb
  class Document < Treetop::Runtime::SyntaxNode
  end

  class Text < Treetop::Runtime::SyntaxNode
    def children
      elements.map{ |e| e.elements }.flatten
    end
  end

  class Eval < Treetop::Runtime::SyntaxNode
  end

  class Tag < Treetop::Runtime::SyntaxNode
  end

  class Control < Treetop::Runtime::SyntaxNode
  end

  class Whitespace < Treetop::Runtime::SyntaxNode
  end

  class Word < Treetop::Runtime::SyntaxNode
  end
end
