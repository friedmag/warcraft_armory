Given /^a character (.*)$/ do |name|
  @name = name
end

Given /^a (.*) server (.*)$/ do |region, server|
  @region = region.downcase.to_sym
  @server = server
  @character = WarcraftArmory::Character.find(
    @region, @server, @name)
end

When /^I ask for (.*)$/ do |field|
  @field = (field.downcase.split(' ') * '_').to_sym
end

Then /^I should get "(.*)"$/ do |expected_value|
  value = @character.send(@field)
  value.should == expected_value
end
