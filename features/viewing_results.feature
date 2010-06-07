@results
Feature: Viewing results
  In order to be able to view the results
  As a regular student
  I want to be able to view the results
  
  Scenario: Viewing results with a submit after the contest is finished
    Given there is a user with attributes:
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
    And I follow "Резултати"
    Then I should see "Резултати от Fall contest"
    And I should not see "Valentin Mihov"
    And I should not see "100"
    And I should not see "20"
    And I should not see "0"
  
  Scenario: Viewing results without submitted solution for one of the problem
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | password              | secret                    |
    And there is a contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 1                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" opens the contest "Fall contest"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | status        | ok ok ok ok ok     |
    And the contest "Fall contest" is finished
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    And I follow "Резултати"
    Then I should see "Резултати от Fall contest"
    And I should see "Valentin Mihov"
    And I should see "100"
    And I should see "20"
    And I should see "0"

  Scenario: Viewing results for a non-visible contest with admin
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | password              | secret                    |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 0                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | language      | C/C++              |
      | status        | ok ok ok ok ok     |
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    When I am on the homepage
    And I follow "Резултати"
    Then I should see "Резултати от Fall contest"
    And I should not see "100"
    And I should not see "20"
    And I should not see "0"

  Scenario: Viewing results for a non-visible contest with regular user
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | password              | secret                    |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 0                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | language      | C/C++              |
      | status        | ok ok ok ok ok     |
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    When I am on the homepage
    Then I should see "Очаквайте скоро"

  Scenario: Viewing directly the results for a non-visible contest with regular user
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | password              | secret                    |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 0                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the contest "Fall contest" has a task named "Problem B"
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | language      | C/C++              |
      | status        | ok ok ok ok ok     |
    When I am on the homepage
    And I follow "влезете"
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"
    When I am on the results page for contest "Fall contest"
    Then I should see "Очаквайте скоро"
