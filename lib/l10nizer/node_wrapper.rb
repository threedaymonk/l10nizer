require 'forwardable'
require 'l10nizer/node'

module L10nizer
  class NodeWrapper
    extend Forwardable

    def_delegator :@keygen, :call, :generate_key

    def initialize(context, keygen)
      @context = context
      @keygen = keygen
    end

    def wrap(node)
      case node
      when @context::Text
        TextNode.new(self, node)
      when @context::Eval
        EvalNode.new(self, node)
      when @context::Word
        WordNode.new(self, node)
      else
        BasicNode.new(self, node)
      end
    end
  end
end
