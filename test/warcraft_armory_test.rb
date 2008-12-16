require 'test/unit'

require "#{File.dirname(__FILE__)}/../init"

class WarcraftArmoryTest < Test::Unit::TestCase
  
  def setup
    @scraped_content = File.read(File.expand_path(File.dirname(__FILE__)) + '/assets/character.xml').to_s
    @character = WarcraftArmory::Character.new("",@scraped_content)
  end
  
  def teardown
    # Nothing
  end

  def test_character_name
    assert_equal 'Crindappy', @character.name
  end
  
  def test_character_title
    assert_equal 'Crindappy the Hallowed', @character.full_name
    assert_equal '%s the Hallowed', @character.current_title_format
  end
  
  def test_character_level
    assert_equal 80, @character.level
  end
  
  def test_character_race
    assert_equal "Gnome", @character.race
  end
  
  def test_character_class
    assert_equal 'Warlock', @character.class_name
  end
  
  # assert_equal 'The Justice League', character.guild
end
