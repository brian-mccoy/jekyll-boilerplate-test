require "nokogiri"
require 'open-uri'

module Jekyll

  class SVG < Liquid::Tag

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/


    # Intialize
    def initialize(tag_name, markup, tokens)
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


     # Get SVG
    def getSVG(variables)

      if variables["path"].nil? or variables["path"].empty?
        return '{svg: Path property is empty.}'
      end

      # Set Height equal to Width if non-existant
      if variables.key? "width" and ! variables.key? "height"
        variables["height"] = variables["width"]
      end

      # Site Source Path
      if variables["path"].start_with? "http"
        svg_file = variables["path"]
        svg_doc = Nokogiri::XML(open(svg_file))
      else
        svg_file = Jekyll.sanitized_path(variables["site"]["destination"], variables["path"])
        svg_doc = Nokogiri::XML(File.open(svg_file))
      end

      # Add/Replace Variables
      variables.each do |key,val| 
        if key == "site" || key == "page" || key == "layout"
          next
        end
        svg_doc.root.set_attribute(key, val)
      end

      # Return
      return svg_doc.to_xml

    end


    # Render
    def render(context)

      variables = getProperties(context)
      return getSVG(variables);

    end

  end

end

Liquid::Template.register_tag('svg', Jekyll::SVG)