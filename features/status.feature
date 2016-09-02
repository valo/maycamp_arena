@status
Feature: Viewing the system status
  In order to be able to view system status
  As a regular student
  I want to be able to view the status

  Background:
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | unencrypted_password  | secret                    |
    And there is a contest with attributes:
      | name          | Test contest       |
      | practicable   | 1                  |
      | visible       | 1                  |
    And the contest "Test contest" has a task named "Task"
    And the user "valo" submit a run for problem "Task" with attributes:
      | status        | ok ok ok ok ok     |
  Scenario: Viewing the status without a logged user
    Given I am on the homepage
    When I follow "Статус"
    Then I should see "Статус на системата - последни събмити"
    And I should see "Valentin Mihov"
    And I should see "ok ok ok ok ok"

  Scenario: Viewing the user info from the status page without a logged user
    Given I am on the homepage
    When I follow "Статус"
    And I follow "Valentin Mihov"
    Then I should see "Valentin Mihov"
