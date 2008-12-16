require 'open-uri'
require "rexml/document"

module WarcraftArmory
  class Character
    def self.find(location, realm, character_name)
      site = "http://#{location.to_s}.wowarmory.com"
      url = "#{site}/character-sheet.xml?r=#{realm}&n=#{character_name}"
      
      WarcraftArmory::Character.new(site,open(url,"User-Agent" => "Mozilla/5.0 (WarcraftArmory) Firefox/3.0.2"))
    end
    
    def initialize(site,xml_or_stream)
      @site = site
      @doc = REXML::Document.new xml_or_stream
      
      info = REXML::XPath.first(@doc,"//characterInfo").attributes
      if (info["errCode"] != nil)
        raise info["errCode"]
      end
      
      @character = REXML::XPath.first(@doc,"//character").attributes
    end
    
    def inspect
      full_name
    end
    
    def current_title_format
      @current_title_format ||= (REXML::XPath.first(@doc,"//title/@value") || "%s").value
    end
    
    def title_formats
      @title_formats ||= REXML::XPath.match(@doc,"//knownTitles/title/@value").map { |x| x.to_s }
      @title_formats << current_title_format if (current_title_format)
    end
    
    def titles
      title_formats.map { |x| sprintf(x,name) }
    end
    
    def full_name
      @full_name ||= sprintf(current_title_format,name)
    end
    
    def name
      @name ||= @character["name"]
    end
    
    def level
      @level ||= @character["level"].to_i
    end
    
    def race
      @race ||= @character["race"]
    end

    def class_name
      @class ||= @character["class"]
    end
  end
end