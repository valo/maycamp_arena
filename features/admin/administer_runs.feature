@admin @runs
Feature: Administer runs
  In order to be able to control the system
  As a administrator
  I want to be able to administer the runs
  
  Background:
    Given there is an admin user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | unencrypted_password  | secret                    |
    And I am not logged in
    And I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2009 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    And I follow "Задачи" within ".post"
    And I follow "Нова задача"
    And I fill in the following:
      | Име: | A+B problem |
      | Time limit: | 1 |
    And I press "Създаване"

  Scenario: Submitting a run
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Решения"
    And I follow "Пращане на решение"
    And I select "Valentin Mihov" from "Потребител:"
    And I fill in the following:
      | Език: | C/C++ |
      | Сорс код: | #include <stdio.h> |
    And I press "Изпрати"
    Then I should be on the runs list on the admin panel
    And I should see "A+B problem"
    And I should see "pending"
    And I should see "Valentin Mihov" within "table.runs_list"
  
  Scenario: Viewing all the runs for a given contest
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Решения"
    And I follow "Пращане на решение"
    And I select "Valentin Mihov" from "Потребител:"
    And I fill in the following:
      | Език: | C/C++ |
      | Сорс код: | #include <stdio.h> |
    And I press "Изпрати"
    When I am on the contest list in the admin panel
    And I follow "Решения"
    Then I should see "pending"
    And I should see "A+B problem"
    And I should not see "Пращане на решение"

  Scenario: Editing a run
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Решения"
    And I follow "Пращане на решение"
    And I select "Valentin Mihov" from "Потребител:"
    And I fill in the following:
      | Език: | C/C++ |
      | Сорс код: | #include <stdio.h> |
    And I press "Изпрати"
    When I am on the contest list in the admin panel
    And I follow "Решения"
    And I follow "Редактиране"
    And I fill in the following:
      | Език: | C/C++ |
      | Сорс код: | #include <iostream> |
    And I press "Промени"
    Then I should see "#include <iostream>"
    And I should see "Source code"
    And I should see "Log"
