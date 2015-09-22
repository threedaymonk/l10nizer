require 'l10nizer/html_erb_parser'
require 'l10nizer/haml_parser'
require 'l10nizer/node_wrapper'

module L10nizer
  class Processor
    def initialize(html, keygen, context = HtmlErb)
      @html = html
      @keygen = keygen
      @context = context
    end

    def l10ns
      processed.inject({}) { |hash, node| hash.merge(node.l10n) }
    end

    def reformed
      processed.map(&:to_s).join
    end

    def processed
      @wrapper = NodeWrapper.new(@context, @keygen)
      @processed ||=
        @context::Parser.new.
        parse(@html).
        elements.
        map { |e| @wrapper.wrap(e) }
    end
  end
end
