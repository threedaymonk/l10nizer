require "l10nizer/parser"
require "l10nizer/node"

module L10nizer
  class Processor
    def initialize(html, keygen)
      @html = html
      @keygen = keygen
    end

    def l10ns
      processed.inject({}) { |hash, node| hash.merge(node.l10n) }
    end

    def reformed
      processed.map(&:to_s).join
    end

    def processed
      @processed ||=
        HtmlErbParser.new
          .parse(@html)
          .elements
          .map { |e| NodeWrapperFactory.wrap(e, @keygen) }
    end
  end
end
