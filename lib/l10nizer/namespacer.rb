module L10nizer
  class Namespacer
    def call(path)
      path.sub(/\.html\.erb$/, "").split(/\/_?/).drop(2).join(".")
    end
  end
end
