# Dollar
# Convert string into dollar
# {{ title | dollar }}

module Dollar

  def separate_comma(number)

    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
    
  end

  def dollar(input)

    if (input.nil? or input.empty?)
      return
    end

    return '$ ' + separate_comma(input)

  end

end

Liquid::Template.register_filter(Dollar)