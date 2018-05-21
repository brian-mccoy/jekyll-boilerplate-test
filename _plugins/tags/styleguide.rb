module Jekyll

  class Styleguide < Liquid::Tag
    
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    # Intialize
    def initialize(tag_name, markup, tokens)
    end


    # Escape HTML
    def escapeHTML(string)
      return string.gsub('&', '&amp;').gsub('%}', '&percnt;&rbrace;').gsub('{%', '&lbrace;&percnt;').gsub('>', '&gt;').gsub('<', '&lt;').gsub('"', '&quot;').gsub("'", '&apos;')
    end


    # Escape HTML
    def newLines(string)
      return string.gsub('&percnt;&rbrace;&lbrace;&percnt;', '&percnt;&rbrace;<br />&lbrace;&percnt;').gsub('&gt;&lt;', '&gt;<br />&lt;').gsub('&gt;&lbrace;&percnt;', '&gt;<br />&lbrace;&percnt;').gsub('&percnt;&rbrace;&lt;', '&percnt;&rbrace;<br />&lt;')
    end


    # Get Markup
    def getMarkup(shortcode)

      # Bail if no title
      if shortcode['markup'].nil? or shortcode['title'].nil? or shortcode['title'].empty?
        return;
      end

      # Container
      html = '<div class="' + shortcode['ext'].gsub('.', '') + '-' + shortcode['base'] + '">'

      # Title
      html += '<h3 id="' + shortcode['base'] + '">' + shortcode['title'] + '<a href="#' + shortcode['base'] + '"><sup>&#9875;</sup></a></h3>'

      # Examples
      if !shortcode['example'].nil? or !shortcode['example_1'].nil?
        html += '<h5>Example</h5>'
        html += '<div class="example">'
        i = 0
        loop do
          example = (i === 0) ? 'example' : 'example_' + i.to_s

          i += 1
          if shortcode[example].nil? or i == 6
            break
          end

          html += (shortcode['ext'] === ".snippet") ? shortcode[example] : shortcode[example].gsub('this', shortcode['base'])
          shortcode.delete(example)
        end
        html += '</div>'
      end
      
      # Markup
      if !shortcode['markup'].nil?
        markup = shortcode['ext'] === ".snippet" ? escapeHTML(shortcode['markup']) : newLines(escapeHTML(shortcode['markup'].gsub('this', shortcode['base'])))

        html += '<h5>Markup</h5><code><pre class="code">' + markup + '<button class="clipboard js-clipboard">Copy</button></pre></code>'
        html += '<div class="clipboard-area"><textarea>' + markup.gsub('<br />', '&#13;') + '</textarea></div>'
      end

      # Additional Properties
      shortcode.each do |property, value|

        if ['base', 'title', 'markup', 'example'].include? property
          next
        end

        case property
        when "ext"
          html += '<h5>Type</h5>' + value.slice(1..-1).capitalize
        else
          html += '<h5>' + property.capitalize + '</h5>' + value
        end

      end

      html += '</div>'

      return html

    end


     # Get Shortcodes HTML
    def getShortcodesHTML()

      html = ''
      shortcodes = Dir.glob('_html/shortcodes/**/*').sort;

      if shortcodes.nil? or shortcodes.empty?
        return html
      end

      # Shortcodes Glob Loop
      shortcodes.each do |file|

        shortcode              = Hash.new
        shortcode['ext']       = File.extname(file);
        shortcode['base']      = File.basename(file, shortcode['ext']);

        if File.directory?(file)
          html += '<h2 id="' + shortcode['base'] + '">' + shortcode['base'].capitalize + '<a href="#' + shortcode['base'] + '"><sup>&#9875;</sup></a></h2>'
          next
        end

        markup = File.read(file);
      
        if markup =~ Syntax

          if shortcode['ext'] === ".snippet"
            snippet              = markup.split('{% endcomment %}')[-1].gsub /^$\n/, '';
            shortcode['markup'] = snippet.to_s
          end

          markup.scan(/\{% comment %\}(.*?)\{% endcomment %\}/m).each do |comment|
            comment = (!comment.first.nil? and !comment.first.empty?) ? comment.first : nil;

            if comment.nil?
              next
            end

            comment.each_line do |line|
              property, value = line.split(": ", 2)

              if property.nil? or value.nil?
                next
              end

              property            = property.gsub("\r", ' ').gsub("\n", ' ').squeeze(' ').strip.downcase.to_s
              value               = value.gsub("\r", ' ').gsub("\n", ' ').squeeze(' ').strip.to_s
              shortcode[property] = value;

            end # comment each end

          end # markup each end

          if !shortcode.nil? and shortcode.is_a?(Hash)
            html += getMarkup(shortcode).to_s
          end

        end # markup syntax end

      end # glob end

      return html

    end


    # Render
    def render(context)

      Liquid::Template.parse(getShortcodesHTML()).render(context);

    end

  end

end

Liquid::Template.register_tag('styleguide', Jekyll::Styleguide)