require "treetop"
require "l10nizer/grammar"

class Treetop::Runtime::SyntaxNode
  def interpret
    "(UNKNOWN: #{text_value.inspect})"
  end
end

module HtmlErb
  module BoringNode
    def to_s
      text_value
    end

    def l10n
      nil
    end
  end

  class Document < Treetop::Runtime::SyntaxNode
    def interpret
      elements.map{ |e| e.interpret } * ", "
    end
  end

  class Tag < Treetop::Runtime::SyntaxNode
    include BoringNode
    def interpret
      "(TAG #{text_value})"
    end
  end

  class Text < Treetop::Runtime::SyntaxNode
    def interpret
      "(TEXT #{children.map{ |e| e.interpret } * ", "})"
    end

    def children
      elements.map{ |e| e.elements }.flatten
    end

    def variable_name(index)
      ("a" .. "z").to_a[index]
    end

    def vars_and_l10n
      @vars_and_l10n ||= (
        l10n = ""
        vars = []
        children.each do |e|
          case e
          when Eval
            l10n << "{{#{variable_name(vars.length)}}}"
            vars << e.content
          else
            l10n << e.to_s
          end
        end
        [vars, l10n]
      )
    end

    def l10n
      vars_and_l10n[1]
    end

    def to_s
      params = [%{"key"}]
      vars_and_l10n[0].each_with_index do |v, i|
        params << %{:#{variable_name(i)} => #{v}}
      end

      %{<%= t(#{params * ", "}) %>}
    end
  end

  class Control < Treetop::Runtime::SyntaxNode
    include BoringNode
    def interpret
      "(CONTROL #{text_value})"
    end
  end

  class Whitespace < Treetop::Runtime::SyntaxNode
    include BoringNode
    def interpret
      "(WS #{text_value.inspect})"
    end
  end

  class Eval < Treetop::Runtime::SyntaxNode
    include BoringNode
    def interpret
      "(EVAL #{text_value})"
    end

    def content
      text_value.gsub(/\A<%=\s*|\s*%>\Z/, "")
    end
  end

  class Word < Treetop::Runtime::SyntaxNode
    include BoringNode
    def interpret
      "(WORD #{text_value})"
    end
  end
end
