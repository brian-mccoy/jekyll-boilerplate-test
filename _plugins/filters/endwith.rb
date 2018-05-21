# EndWith
# Append if doesn't already have it.
# {{ url | endwith: "/" }}

module EndWith

  def endwith(content, endwith_content = "")

    # Return Empty
    if (content.nil? or content.empty?) and (endwith_content.nil? or endwith_content.empty?)
      return
    end

    return (content.end_with? endwith_content) ? content : content + endwith_content

  end

end

Liquid::Template.register_filter(EndWith)