require 'rubygems'
require 'algoliasearch'
require 'awesome_print'

module Jekyll

  class AlgoliaRankings < Liquid::Tag

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/


    # Intialize
    def initialize(tag_name, markup, tokens)

      @template = Liquid::Template.parse(File.read('_html/shortcodes/modules/rankings_list.html'))
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


    # Algolia Setup
    def setupAlgolia(settings)
      
      Algolia.init(application_id: settings['api_id'], api_key: settings['api_key'])

      @index_rankings = Algolia::Index.new(settings['rankings'])
      @index_items    = Algolia::Index.new(settings['rankings_items'])

    end


     # Ranking Properties
    def getRankingProperties(id)

      if (id.nil? or id.empty?) or @index_rankings.nil?
        return;
      end 

      # Exception Handling for Get Ranking Properties
      begin  
        results = @index_rankings.get_object(id, 'title,ranking_cpt_slug')
      rescue  
        results = nil
      end  

      if results.nil?
        return Hash.new
      end
      
      return results

    end


    # Ranking Items
    def getRankingItems(id, limit)

      if (id.nil? or id.empty?) or @index_items.nil?
        return;
      end 

      params = Hash.new
      params['hitsPerPage'] = (limit.nil? or limit.empty?) ? 100 : limit
      params['filters']     = 'post_id:' + id

      # Exception Handling for Get Ranking List
      begin  
        results = @index_items.search('', params)
      rescue  
        results = nil
      end

      if results.nil?
        return Hash.new
      end

      return results['hits']

    end


    # Render
    def render(context)

      # Get Properties
      variables = getProperties(context)

      # Bail
      if variables['site']['algolia'].nil? or variables['site']['algolia'].empty?
        return 'Config Algolila settings not setup.'
      end

      # Setup Algolia
      setupAlgolia(variables['site']['algolia'])

      # Get Ranking List Properties
      variables['ranking'] = getRankingProperties(variables['id'])

      # Get Ranking List Items
      variables['ranking']['results'] = getRankingItems(variables['id'], variables['preview_top'])

      # Return if no Rankings/Results
      if variables['ranking'].empty? or variables['ranking']['results'].empty?
        return
      end

      # Render Template with Properties
      @template.render(variables)

    end

  end

end

Liquid::Template.register_tag('rankings_list', Jekyll::AlgoliaRankings)