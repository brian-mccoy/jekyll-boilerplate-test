# Slugify
# Creates a sanitized string
# {% assign hashtag = title | slugify %}

require "nokogiri"

module Slugify

  def slugify(input)

    if (input.nil? or input.empty?)
      return
    end

    input = Nokogiri::HTML.parse input;
    input = input.text.gsub(/[^0-9a-z ]/i, '')
    input = downcase(replace(input.to_s.strip, ' ', '-'))
    
    return input

  end

end

Liquid::Template.register_filter(Slugify)