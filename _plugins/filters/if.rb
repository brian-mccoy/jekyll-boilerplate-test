# If
# If image exists print primary argument.
# {{ image | if:" has-image" }}

module If

  def if(content, if_content = "")

    # Return Empty
    if (content.nil? or content.empty?) and (if_content.nil? or if_content.empty?)
      return
    end

    return (!content.nil? and !content.empty?) ? if_content : ''

  end

end

Liquid::Template.register_filter(If)