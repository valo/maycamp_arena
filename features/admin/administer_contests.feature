@admin @contests
Feature: Administer contests
  In order to be able to control the system
  As a administrator
  I want to be able to administer the contests
  
  Background:
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | password              | secret                    |
    And I am not logged in
    And I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"

  Scenario: Create new contest
    Given I am on the contest list in the admin panel
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2009 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    Then I should be on the contest list in the admin panel
    And I should see "Fall contest"
    And I should see "2 часа"

  Scenario: Delete a contest
    Given I am on the contest list in the admin panel
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2009 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    And I follow "Изтриване"
    Then I should be on the contest list in the admin panel
    And I should not see "Fall contest"
    And I should not see "2 часа"

  Scenario: Edit a contest
    Given I am on the contest list in the admin panel
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2009 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    And I follow "Промяна"
    And I fill in the following:
      | Име: | Spring contest |
      | Продължителност: | 180 |
    And I press "Обновяване"
    Then I should be on the contest edit page in the admin panel
    And I should see "Състезанието е обновено успешно."

  Scenario: Edit a contest and go to the index page
    Given I am on the contest list in the admin panel
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2009 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    And I follow "Промяна"
    And I fill in the following:
      | Име: | Spring contest |
      | Продължителност: | 180 |
    And I press "Обновяване"
    And I follow "Отказ"
    Then I should be on the contest list in the admin panel
    And I should see "Spring contest"
