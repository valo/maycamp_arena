Feature: User stats
  In order to be able to view the stats of a user
  As a visitor
  I want to be able to browse the users

  Scenario: Open a user stats as anonmous user
    Given there is a user with attributes:
      | name                  | Valentin Mihov            |
    When I am on the user stats page for user "Valentin Mihov"
    Then I should see "Статистика"

  Scenario: Open a user stats for a user with external contests as anonmous
    Given there is a user with attributes:
      | name                  | Valentin Mihov            |
    And there is an external_contest_result for user "Valentin Mihov"
    When I am on the user stats page for user "Valentin Mihov"
    Then I should see "Статистика"

  Scenario: Update user profile
    Given I am logged in as contestant user with attributes:
      | name | Valentin Mihov |
    And I am on the profile page of "Valentin Mihov"
    When I fill in the following:
      | Истинско име: | Pesho Peshev |
    And I press "Обнови"
    Then I should not see "Valentin Mihov"
    And I should see "Pesho Peshev"

  Scenario: Update user profile
    Given I am logged in as contestant user with attributes:
      | name | Valentin Mihov |
    And there is a finished contest with attributes:
      | name        | Fall contest |
      | practicable | true         |
    And I am on the homepage
    And I follow "Практикувай"
    Then I should see "Практикуване на Fall contest"
