# Else
# If image exists, print variable otherwise print input.
# {{ image | else:" has-image" }}

module Else

  def else(content, else_content = "")

    if (content.nil? or content.empty?) and (else_content.nil? or else_content.empty?)
      return
    end

    return (!content.nil? and !content.empty?) ? '' : else_content

  end

end

Liquid::Template.register_filter(Else)