# Ternary
# If image exists, print variable otherwise print input.
# {{ image | ternary: " has-image" }}

module Ternary

  def ternary(content, ternary_content = "")

    if (content.nil? or content.empty?) and (ternary_content.nil? or ternary_content.empty?)
      return
    end

    return (!content.nil? and !content.empty?) ? content : ternary_content

  end

end

Liquid::Template.register_filter(Ternary)