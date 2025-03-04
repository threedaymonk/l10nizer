module L10nizer
  class KeyGenerator
    attr_accessor :namespace

    def initialize
      @seen = {}
    end

    def call(string)
      provisional = [make_safe(namespace), make_safe(string)].compact * "."

      until distinct?(provisional, string)
        match = provisional.match(/_(\d+)$/)
        if match
          provisional = provisional.sub(/\d+$/, match[1].to_i.succ.to_s)
        else
          provisional += "_1"
        end
      end

      provisional
    end

    private

    def distinct?(key, string)
      if [nil, string].include?(@seen[key])
        @seen[key] = string
        true
      else
        false
      end
    end

    def make_safe(string)
      return nil if string.nil?
      safe = string
        .downcase
        .gsub(/&[a-z0-9]{1,20};/, "") # entities
        .gsub(/<[^>]*>/, "")          # html
        .gsub(/[^a-z0-9.]+/, "_")     # non alphanumeric
        .slice(0, 40)                 # limit length
        .gsub(/^_|_$/, "")            # leading/trailing _
      safe = "unknown" if safe.empty?
      safe
    end
  end
end
