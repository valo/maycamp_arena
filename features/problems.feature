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
    And the contest "Test contest" has a task named "A+B Problem"

  Scenario: View all the problems
    Given I am on the homepage
    When I follow "Задачи"
    Then I should see "A+B Problem"

  Scenario: Open problem
    Given I am on the homepage
    When I follow "Задачи"
    And I follow "A+B Problem"
