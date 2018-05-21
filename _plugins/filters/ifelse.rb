# IfElse
# If image exists print primary argument otherwise print secondary argument.
# {{ image | iflese:" has-image", "" }}

module IfElse

  def iflese(content, if_content = "", else_content = "")

    # Return Empty
    if (content.nil? or content.empty?) and (if_content.nil? or if_content.empty?) and (else_content.nil? or else_content.empty?)
      return
    end

    return (!content.nil? and !content.empty?) ? if_content : else_content

  end

end

Liquid::Template.register_filter(IfElse)