# StartWith
# Prepend if doesn't already have it.
# {{ url | startwith: "https://" }}

module StartWith

  def startwith(content, startwidth_content = "")

    # Return Empty
    if (content.nil? or content.empty?) and (startwidth_content.nil? or startwidth_content.empty?)
      return
    end

    return (content.start_with? startwidth_content) ? content : startwidth_content + content

  end

end

Liquid::Template.register_filter(StartWith)