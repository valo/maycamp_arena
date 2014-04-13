@categories
Feature: Categires
In order to be able to categorize the task
As a regular user
I want to be able to use categories

  Background:
    Given there is a contest with attributes:
      | name          | Test contest       |
      | practicable   | 1                  |
      | visible       | 1                  |
    And the contest "Test contest" has a task named "A+B Problem"
    And there is a category with attributes:
      | name                  | Динамично             |
    And the problem "A+B Problem" belongs to the category "Динамично"

  Scenario: View the problems in a category
    Given I am on the homepage
    When I follow "Задачи"
    And I follow "Задачи по категории"
    And I follow "Динамично"
    Then I should see "A+B Problem"

  Scenario: View the problems in a category
    Given I am on the homepage
    When I follow "Задачи"
    And I follow "Задачи по категории"
    And I follow "Динамично"
    And I follow "A+B Problem"
    Then I should be on the login page

  Scenario: Try to view invisible problems in a category
    Given I am on the homepage
    And the contest "Test contest" has attributes:
      | practicable   | 1                  |
      | visible       | 0                  |
    When I follow "Задачи"
    And I follow "Задачи по категории"
    And I follow "Динамично"
    Then I should not see "A+B Problem"

  Scenario: Try to view invisible problems in a category
    Given I am on the homepage
    And the contest "Test contest" has attributes:
      | practicable   | 0                  |
      | visible       | 1                  |
    When I follow "Задачи"
    And I follow "Задачи по категории"
    And I follow "Динамично"
    Then I should not see "A+B Problem"
