module L10nizer
  class NodeWrapperFactory
    def self.wrap(node, keygen = nil)
      case node
      when HtmlErb::Text
        TextNode.new(node, keygen)
      when HtmlErb::Eval
        EvalNode.new(node, keygen)
      when HtmlErb::Word
        WordNode.new(node)
      else
        BasicNode.new(node)
      end
    end
  end

  class BasicNode
    def initialize(node, keygen = nil)
      @node = node
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

    def string?
      false
    end
  end

  class TextNode < BasicNode
    def l10n
      _, text = vars_and_text
      text ? {key => text} : {}
    end

    def to_s
      vars, _ = vars_and_text
      return super unless vars

      params = ['".' + key.split(".").last + '"']
      vars.each_with_index do |v, i|
        params << %{#{variable_name(i)}: (#{v})}
      end

      %{<%= t(#{params * ", "}) %>}
    end

    private

    def children
      @node.children.map { |e| NodeWrapperFactory.wrap(e) }
    end

    def variable_name(index)
      ("a".."z").to_a[index]
    end

    # rubocop:disable Metrics/MethodLength
    def vars_and_text
      @vars_and_text ||= if children.all?(&:evaluated?) || children.none?(&:string?)
        []
      else
        l10n = ""
        vars = []
        children.each do |e|
          if e.evaluated?
            l10n << "%{#{variable_name(vars.length)}}"
            vars << e.to_s
          else
            l10n << e.to_s
          end
        end
        [vars, l10n]
      end
    end
    # rubocop:enable Metrics/MethodLength

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

  class WordNode < BasicNode
    def string?
      true
    end
  end
end
