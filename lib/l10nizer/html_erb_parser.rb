require 'treetop'
require 'polyglot'
require 'l10nizer/html_erb_grammar'

module HtmlErb
  class Document < Treetop::Runtime::SyntaxNode
  end

  class Text < Treetop::Runtime::SyntaxNode
    def children
      elements.flat_map(&:elements)
    end
  end

  class Eval < Treetop::Runtime::SyntaxNode
    def text_value
      super[/\A<%=\s*(.*?)\s*%>\Z/, 1]
    end
  end

  class Word < Treetop::Runtime::SyntaxNode
  end

  class Emitter
    def interpolate(s)
      %{<%= #{s} %>}
    end
  end

  Parser = HtmlErbParser
end
