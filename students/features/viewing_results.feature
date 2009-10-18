@results
Feature: Viewing results
  In order to be able to view the results
  As a regular student
  I want to be able to view the results
  
  Scenario: Viewing results without submitted solution for one of the problem
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | password              | secret                    |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | about                 | The contest during Fall   |
      | duration              | 120                       |
      | results_visible       | 1                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | language      | C/C++              |
      | source_code   | #include <stdio.h> |
      | status        | ok ok ok ok ok     |
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    And I follow "Резултати"
    Then I should see "100"
    And I should see "20"
    And I should see "0"
