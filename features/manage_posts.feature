Feature: Manage posts as a logged in user
  In order to demonstrate the features of the Bobby Gem and verify that Cucumber works
  as a user I
  wants to be able to add new posts
  
  Background: Logged in 
	Given I am a new, authenticated user 
	
  Scenario: Register new post
    Given I am on the new post page
    When I fill in "Title" with "title 1"
    And I fill in "Body" with "body 1"
    And I press "Create"
    Then I should see "title 1"
    And I should see "body 1"

  Scenario: Delete post
    Given the following posts:
      |title|body|
      |title 1|body 1|
      |title 2|body 2|
      |title 3|body 3|
      |title 4|body 4|
    When I delete the 3rd post
    Then I should see the following posts:
      |Title|Body|
      |title 1|body 1|
      |title 2|body 2|
      |title 4|body 4|
