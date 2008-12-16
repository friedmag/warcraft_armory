module WarcraftArmory
  class CharacterLite
    def initialize(site,attributes)
      @site = site
      
      @character = attributes
    end
    
    def inspect
      name
    end
    
    def name
      @name ||= @character["name"]
    end
    
    def faction
      @faction ||= WarcraftArmory.getFaction(@character["factionId"].to_i)
    end
    
    def level
      @level ||= @character["level"].to_i
    end
    
    def race
      @race ||= WarcraftArmory.getRace(@character["raceId"].to_i)
    end
    
    def gender
      @gender ||= WarcraftArmory.getGender(@character["genderId"].to_i)
    end

    def class_name
      @class ||= WarcraftArmory.getClass(@character["classId"].to_i)
    end
    
    def urlSuffix
      @urlSuffix ||= (@character["url"] || @character["charUrl"])
    end
    
    def full_character(location = nil)
      @site ||= "http://#{location.to_s}.wowarmory.com"
      WarcraftArmory::Character.fetch(@site,urlSuffix)
    end
  end
end