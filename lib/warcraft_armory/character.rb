require 'open-uri'
require "rexml/document"
require "cgi"

module WarcraftArmory
  class Character < CharacterLite
    def self.find(location, realm, character_name)
      site = "http://#{location.to_s}.wowarmory.com"
      url = "#{site}/character-sheet.xml?r=#{CGI.escape realm}&n=#{CGI.escape character_name}"
      
      WarcraftArmory::Character.new(site,open(url,"User-Agent" => "Mozilla/5.0 (WarcraftArmory) Firefox/3.0.2"))
    end

    def self.fetch(site,urlArgs)
      url = "#{site}/character-sheet.xml?#{urlArgs}"
      WarcraftArmory::Character.new(site,open(url,"User-Agent" => "Mozilla/5.0 (WarcraftArmory) Firefox/3.0.2"))
    end
    
    def initialize(site,xml_or_stream)
      @doc = REXML::Document.new xml_or_stream
      
      info = REXML::XPath.first(@doc,"//characterInfo").attributes
      if (info["errCode"] != nil)
        raise info["errCode"]
      end
      
      attribs = REXML::XPath.first(@doc,"//character").attributes
      
      super(site,attribs)
    end
    
    def inspect
      full_name
    end
    
    def current_title_format
      @current_title_format ||= (REXML::XPath.first(@doc,"//title/@value") || "%s").value
    end
    
    def title_formats
      @title_formats ||= _build_title_formats
    end
    
    def titles
      title_formats.map { |x| sprintf(x,name) }
    end
    
    def full_name
      @full_name ||= sprintf(current_title_format,name)
    end
    
    def guild
      @guild ||= _guild
    end

    def full_character(location = nil)
      self
    end
    
    private
    def _build_title_formats
      tf = REXML::XPath.match(@doc,"//knownTitles/title/@value").map { |x| x.to_s }
      tf << current_title_format if (current_title_format)
      tf.sort
    end
    
    def _guild
      if (@character["guildName"] == nil)
        nil
      elsif (@site)
        WarcraftArmory::Guild.fetch(@site,@character['guildUrl'])
      else
        WarcraftArmory::GuildLite.new(@character)
      end
    end
  end
end