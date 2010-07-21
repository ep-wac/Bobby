Feature: Installing Bobby
  In order to control access to actions on controllers and instances of models
  As a humble corners-cutting Rails/JavaScript developer
  I want to install bobby into my Rails app

  Background:
    Given a Rails app
	And I have the generator in "lib/generators/bobby"
  
  Scenario: Setup the Bobby
    Given I have bobby installed
    When I invoke "bobby:install" generator 
	And I invoke task "rake db:migrate"
    Then I can instanciate the models "Authorisation GroupUser GroupUsersUsers Permission PermissionsRoles Role"
