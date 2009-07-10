module L10nizer
  class NodeWrapperFactory
    def self.wrap(node, keygen=nil)
      case node
      when HtmlErb::Text
        TextNode.new(node, keygen)
      when HtmlErb::Eval
        EvalNode.new(node, keygen)
      else
        BasicNode.new(node)
      end
    end
  end

  class BasicNode
    def initialize(node, keygen=nil)
      @node   = node
      @keygen = keygen
    end

    def l10n
      {}
    end

    def to_s
      @node.text_value
    end

    def evaluated?
      false
    end
  end

  class TextNode < BasicNode
    def children
      @node.elements.map{ |e| e.elements }.flatten.map{ |e| NodeWrapperFactory.wrap(e) }
    end

    def variable_name(index)
      ("a" .. "z").to_a[index]
    end

    def vars_and_text
      @vars_and_text ||= (
        if children.all?{ |c| c.evaluated? }
          []
        else
          l10n = ""
          vars = []
          children.each do |e|
            if e.evaluated?
              l10n << "{{#{variable_name(vars.length)}}}"
              vars << e.to_s
            else
              l10n << e.to_s
            end
          end
          [vars, l10n]
        end
      )
    end

    def l10n
      _, text = vars_and_text
      text ? {key => text} : {}
    end

    def to_s
      vars, _ = vars_and_text
      return super unless vars

      params = ['"' + key + '"']
      vars.each_with_index do |v, i|
        params << %{:#{variable_name(i)} => #{v}}
      end

      %{<%= t(#{params * ", "}) %>}
    end

    def key
      _, text = vars_and_text
      @key ||= @keygen.call(text)
    end
  end

  class EvalNode < BasicNode
    def to_s
      super[/\A<%=\s*(.*?)\s*%>\Z/, 1]
    end

    def evaluated?
      true
    end
  end
end
