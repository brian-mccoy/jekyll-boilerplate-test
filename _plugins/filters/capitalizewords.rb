# Capitalize Words
# {{ string | capitalizewords }}

module CapitalizeWords

  def capitalizewords(words)
    words.split(' ').map(&:capitalize).join(' ')
  end

end

Liquid::Template.register_filter(CapitalizeWords)