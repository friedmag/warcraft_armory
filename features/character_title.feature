Feature: Retrieve character title format
  Users should be able to
  retrieve character titles

Scenario: Retrieve character title format
  Given a character Gehzry
  And a US server Draka
  When I ask for current title format
  Then I should get "%s the Undying"
