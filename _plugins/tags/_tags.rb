$directory = "_html/shortcodes/"

module Jekyll

  class CustomTags < Liquid::Tag

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/


    # Intialize
    def initialize(tag_name, markup, tokens)

      tag_file  = Dir.glob($directory + '**/' + tag_name + '.tag')
      @template = Liquid::Template.parse(File.read(tag_file.first))
      @markup   = markup
      @tag_name = tag_name
      super

    end


    # Get Static/Dynamic Properties
    def getProperties(context, content = '')

      # Properties Attribute
      variables            = Hash.new
      variables['content'] = content;
      variables['site']    = !context['site'].nil? ? context['site'] : context.registers[:site].config;
      variables['page']    = context['page'];
      variables['layout']  = context['layout'];
      site_variables       = !variables['site'][@tag_name].nil? ? variables['site'][@tag_name] : Hash.new;
      layout_variables     = !variables['layout'][@tag_name].nil? ? variables['layout'][@tag_name] : Hash.new;
      page_variables       = !variables['page'][@tag_name].nil? ? variables['page'][@tag_name] : Hash.new;
      global_vars          = site_variables.merge!(layout_variables).merge!(page_variables)

      # Property Variables
      if @markup =~ Syntax

        # Property Variables from Parent Context
        @markup.scan(Liquid::TagAttributes) do |key, value|
          variables[key] = value.to_s.gsub(/^'|"/, '').gsub(/'|"$/, '').to_s
        end

        # Property Variables from Parent Context
        properties = @markup.gsub(/\:\"(.*?)\"\s+/, " ").gsub(/\:\'(.*?)\'\s+/, " ").gsub(/\:(.*?)\s+/, " ").to_s

        properties.split(" ").each do |key|
          value = context[key].to_s

          if variables[key].nil? && !value.empty?
            variables[key] = value.gsub(/^'|"/, '').gsub(/'|"$/, '').strip
          end      
        end

      end

      # Page, Layout & Config Variables
      if !global_vars.empty?
        global_vars.each do |key, value|
          if variables[key].nil? && !value.nil?
            variables[key] = value.to_s.gsub(/^'|"/, '').gsub(/'|"$/, '').strip
          end  
        end
      end

      return variables

    end


    # Render
    def render(context)

      # Render Template with Properties
      @template.render(getProperties(context))

    end

  end

end

# Loop Shortcode/Tags Directory For Tags
Dir.glob($directory + '**/*.tag') do |file|
  tag = File.basename(file, ".tag")
  Liquid::Template.register_tag(tag, Jekyll::CustomTags)
end