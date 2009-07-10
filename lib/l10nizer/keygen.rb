module L10nizer
  class KeyGenerator
    attr_accessor :namespace

    def initialize
      @seen = {}
    end

    def call(string)
      provisional = [make_safe(namespace), make_safe(string)].compact * "."

      until try(provisional, string)
        provisional.sub!(/(?:_\d+)?$/){ |m| "_" + m.to_i.succ.to_s }
      end

      return provisional
    end

    def try(key, string)
      if [nil, string].include?(@seen[key])
        @seen[key] = string
        true
      else
        false
      end
    end

    def make_safe(string)
      return nil if string.nil?
      string.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "")[0, 40]
    end
  end
end