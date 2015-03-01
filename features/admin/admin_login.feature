@admin
Feature: Administrator login
  In order to be able to control the system
  As a administrator
  I want to be able to login as an administrator
  
  Scenario: Login to the admin panel
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | unencrypted_password  | secret                    |
    And I am not logged in
    When I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"
    Then I should see "Valentin Mihov (Изход)"
    And I should be on the homepage
