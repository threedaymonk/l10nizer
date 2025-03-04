module L10nizer
  class LocaleGenerator
    def call(l10ns, lang: "en")
      lang_tree = l10ns.each_with_object({}) { |(key, value), hash|
        parts = key.split(".")
        parts[0..-2].inject(hash) { |h, k| h[k] ||= {} }[parts.last] = value
      }
      {lang => lang_tree}
    end
  end
end
