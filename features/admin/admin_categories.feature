@admin @categories
Feature: Administer categories
  In order to be able to control the system
  As an administrator
  I want to be able to control the categories

  Background:
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | password              | secret                    |
    And I am not logged in
    When I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"

  Scenario: Create new category
    Given I am on the homepage
    And I follow "Задачи"
    And I follow "Нова категория"
    When I fill in the following:
      | Име: | Динамично програмиране |
    And I press "Създаване"
    Then I should be on the categories list in the admin panel
    And I should see "Динамично програмиране"

  Scenario: Cancel creation of a new category
    Given I am on the homepage
    And I follow "Задачи"
    And I follow "Нова категория"
    And I follow "Отказ"
    Then I should be on the categories list in the admin panel

  Scenario: Delete a category
    Given I am on the homepage
    And I follow "Задачи"
    And I follow "Нова категория"
    When I fill in the following:
      | Име: | Динамично програмиране |
    And I press "Създаване"
    And I follow "Изтрий"
    Then I should be on the categories list in the admin panel
    And I should not see "Динамично програмиране"

  Scenario: Update a category
    Given I am on the homepage
    And I follow "Задачи"
    And I follow "Нова категория"
    When I fill in the following:
      | Име: | Динамично програмиране |
    And I press "Създаване"
    And I follow "Промени"
    When I fill in the following:
      | Име: | Алчни алгоритми |
    And I press "Обновяване"
    Then I should be on the categories list in the admin panel
    And I should not see "Динамично програмиране"
    And I should see "Алчни алгоритми"

  Scenario: Cancel update a category
    Given I am on the homepage
    And I follow "Задачи"
    And I follow "Нова категория"
    When I fill in the following:
      | Име: | Динамично програмиране |
    And I press "Създаване"
    And I follow "Промени"
    When I fill in the following:
      | Име: | Алчни алгоритми |
    And I follow "Отказ"
    Then I should be on the categories list in the admin panel
    And I should see "Динамично програмиране"
    And I should not see "Алчни алгоритми"
