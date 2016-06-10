@admin @groups
Feature: Administer groups
  In order to be able to control the system
  As an administrator
  I want to be able to control the groups

  Background:
    Given there is an admin user with attributes:
      | login                | valo                     |
      | name                 | Valentin Mihov           |
      | email                | valentin.mihov@gmail.com |
      | unencrypted_password | secret                   |
    And I am not logged in
    When I am on the login page
    And I fill in the following:
      | login    | valo   |
      | password | secret |
    And I press "Влез"

  Scenario: Create new group
    Given I am on the groups list in the admin panel
    And I follow "Нова група"
    When I fill in the following:
      | Име: | НОИ |
    And I press "Създаване"
    Then I should be on the groups list in the admin panel
    And I should see "НОИ"

  Scenario: Cancel creation of a new group
  Given I am on the groups list in the admin panel
    And I follow "Нова група"
    And I follow "Отказ"
    Then I should be on the groups list in the admin panel

  Scenario: Delete a group
  Given I am on the groups list in the admin panel
    And I follow "Нова група"
    When I fill in the following:
      | Име: | НОИ |
    And I press "Създаване"
    And I follow "Изтрий"
    Then I should be on the groups list in the admin panel
    And I should not see "НОИ"

  Scenario: Update a group
  Given I am on the groups list in the admin panel
    And I follow "Нова група"
    When I fill in the following:
      | Име: | НОИ |
    And I press "Създаване"
    And I follow "Промени"
    When I fill in the following:
      | Име: | Пролетен турнир |
    And I press "Обновяване"
    Then I should be on the groups list in the admin panel
    And I should not see "НОИ"
    And I should see "Пролетен турнир"

  Scenario: Cancel update a group
  Given I am on the groups list in the admin panel
    And I follow "Нова група"
    When I fill in the following:
      | Име: | НОИ |
    And I press "Създаване"
    And I follow "Промени"
    When I fill in the following:
      | Име: | Пролетен турнир |
    And I follow "Отказ"
    Then I should be on the groups list in the admin panel
    And I should see "НОИ"
    And I should not see "Пролетен турнир"
