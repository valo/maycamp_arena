@admin @status
Feature: Viewing the status
  In order to see what is going on with the system
  As an admin
  I want to be able to view the status of the system

  Scenario: Viewing the status
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | password              | secret                    |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 1                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | status        | ok ok ok ok ok     |
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    And I am on the status in the admin panel 
    Then I should see "Valentin Mihov"
    And I should see "ok ok ok ok ok"
    And I should see "Разглеждане"
    And I should see "Fall contest"
    And I should see "Problem A"
