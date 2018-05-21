require "nokogiri"

module Jekyll
  class SubNavigationGenerator < Generator
    safe true
    priority :high
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def generate(site)
      site.collections.each do |key, collection|
        if collection.docs.nil? or collection.docs.empty? 
          next
        end

        collection.docs.each do |page|
          navItems  = Hash.new
          introItem = Hash.new
          markup    = page.content

          if markup =~ Syntax
            markup.scan(/\{% subnav_item(.*?)\{% endsubnav_item %\}/m).each do |value|
              tag     = '{% subnav_item' + value.first + '{% endsubnav_item %}'
              tag     = tag.gsub("\r", ' ').gsub("\n", ' ').squeeze(' ')
              hashtag = !tag[/hashtag\:(.*?)\s/, 1].nil? ? tag[/hashtag\:(.*?)\s/, 1].gsub(/^'|"/, '').gsub(/'|"$/, '').to_s : nil
              title   = !tag[/title\:(.*?)\s/, 1].nil? ? tag[/title\:(.*?)\s/, 1].gsub(/^'|"/, '').gsub(/'|"$/, '').to_s : nil
              content = !tag[/%\}(.*?)\{%/, 1].nil? ? tag[/%\}(.*?)\{%/, 1].to_s : nil

              if title.nil? and !content.nil?
                content = Nokogiri::HTML.parse content;
                title   = content.text;
              end

              if hashtag.nil? and !title.nil?
                hashtag = content.text.gsub(/[^0-9a-z ]/i, '').to_s.strip.downcase.gsub ' ', '-'
              end

              navItems[hashtag] = title.strip
            end

            if !navItems.empty?
              if !page.data["title"].nil? and !page.data["title"].empty?
                introHash = page.data["title"].gsub(/[^0-9a-z ]/i, '').to_s.strip.downcase.gsub ' ', '-'
                introItem[introHash] = page.data["title"].strip
                navItems = introItem.merge(navItems)
              end

              page.data["subnav"] = navItems
            end
          end
        end
      end
    end
  end
end