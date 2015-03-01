@admin @users
Feature: Administer users
  In order to be able to control the system
  As an administrator
  I want to be able to control the users

  Background:
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | unencrypted_password  | secret                    |
    And I am not logged in
    When I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"

  Scenario: Create new user
    Given I am on the user list in the admin panel
    And I follow "Нов потребител"
    When I fill in the following:
      | Потребителско име: | pesho                  |
      | Истинско име:      | Pesho Peshev           |
      | Email:             | pesho.peshev@gmail.com |
      | Парола             | secret                 |
      | Паролата отново:   | secret                 |
      | Град:              | София                  |
    And I press "Създаване"
    Then I should be on the user list in the admin panel
    And I should see "pesho"

  Scenario: Create new user and login
    Given I am on the user list in the admin panel
    And I follow "Нов потребител"
    When I fill in the following:
      | Потребителско име: | pesho                  |
      | Истинско име:      | Pesho Peshev           |
      | Email:             | pesho.peshev@gmail.com |
      | Парола             | secret                 |
      | Паролата отново:   | secret                 |
      | Град:              | София                  |
    And I press "Създаване"
    And I follow "Valentin Mihov (Изход)"
    And I am on the login page
    And I fill in the following:
      | login | pesho |
      | password | secret |
    And I press "Влез"
    Then I should be on the homepage
    And I should see "Pesho Peshev (Изход)"

  Scenario: View a user
    Given there is a running contest named "Fall championship"
    And the contest "Fall championship" has a task named "A+B Problem"
    And the user "valo" submits a source for problem "A+B Problem"
    When I am on the user list in the admin panel
    And I follow "Админ преглед"
    Then I should see "A+B Problem" within "table.runs_list"

  Scenario: Update a user
    Given I am on the user list in the admin panel
    When I follow "Промяна"
    And I fill in the following:
      | Истинско име:      | Pesho Peshev           |
    And I press "Обновяване"
    And I am not logged in
    And I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"
    Then I should be on the homepage
    And I should see "Pesho Peshev (Изход)"
