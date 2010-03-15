@rankings
Feature: View rankings of the users
  In order to be able to see who is the best programmer
  As a guest
  I want to be able to see the rankings of the students
  
  Scenario: Viewing the rankings page
    Given there is an admin user with attributes:
      | login | root         |
      | name  | Pesho Admina |
    And there is a user with attributes:
      | login | valo           |
      | name  | Valentin Mihov |
    And there is a finished contest with attributes:
      | name                  | Fall contest              |
      | results_visible       | 1                         |
    And the contest "Fall contest" has a task named "Problem A"
    And the user "root" submit a run for problem "Problem A" with attributes:
      | status        | ok ok ok tl ok     |
    And the user "valo" submit a run for problem "Problem A" with attributes:
      | status        | ok ok ok ok ok     |
    When I am on the rankings page
    Then I should not see "Pesho Admina"
    And I should see "Valentin Mihov"
