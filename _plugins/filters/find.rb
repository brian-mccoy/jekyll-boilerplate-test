# Count
# Returns the instances of specified characters
# {{ content | count: "content-card" }}

module Find

  def find(haystack, needle)

    if (haystack.nil? or haystack.empty?) or (needle.nil? or needle.empty?)
      return
    end

    haystack.scan(needle).count

  end

end

Liquid::Template.register_filter(Find)