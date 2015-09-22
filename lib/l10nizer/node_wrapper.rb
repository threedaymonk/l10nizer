require 'forwardable'
require 'l10nizer/node'

module L10nizer
  class NodeWrapper
    extend Forwardable

    def_delegator :@keygen, :call, :generate_key
    def_delegators :@emitter, :interpolate

    def initialize(context, keygen)
      @context = context
      @keygen = keygen
      @emitter = context::Emitter.new
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
