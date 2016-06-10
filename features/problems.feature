@problems
Feature: Problems
In order to be able to categorize the task
As a regular user
I want to be able to use categories

  Background:
    Given there is a contest with attributes:
      | name          | Test contest       |
      | practicable   | 1                  |
      | visible       | 1                  |
    And there is a user with attributes:
      | login | valo           |
      | name  | Valentin Mihov |
    And the contest "Test contest" has a task named "A+B Problem"
    And the user "valo" submit a run for problem "A+B Problem" with attributes:
      | status        | ok ok ok ok ok     |

  Scenario: View all the problems
    Given I am on the homepage
    When I follow "Задачи"
    Then I should see "A+B Problem"

  Scenario: Open problem
    Given I am on the homepage
    When I follow "Задачи"
    And I follow "A+B Problem"

  Scenario: Open problem runs
    Given I am on the homepage
    When I follow "Задачи"
    And I follow "Решения"
    Then I should see "ok"
