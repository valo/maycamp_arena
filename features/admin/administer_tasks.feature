@admin @problems
  Feature: Administer tasks
  In order to be able to control the system
  As a administrator
  I want to be able to administer the tasks

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
    And I follow "Състезания"
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Продължителност: | 120 |
    And I select "October 16, 2014 16:21:39" as the "Начало:" datetime
    And I select "October 18, 2014 16:21:39" as the "Край:" datetime
    And I press "Създаване"
    And I follow "Задачи" within ".post"
    And I follow "Нова задача"
    And I fill in the following:
      | Име: | A+B problem |
      | Time limit: | 1.0 |
    And I press "Създаване"

  Scenario: Create new task
    Then I should be on the problem list for contest "Fall contest" in the admin panel
    And I should see "A+B problem"

  Scenario: Delete task
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Изтриване"
    Then I should be on the problem list for contest "Fall contest" in the admin panel
    And I should not see "A+B problem"

  Scenario: View task
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Преглед"
    Then I should see "Име: A+B problem"
    And I should see "Time limit: 1.0 sec"
    And I should see "Memory limit: 16 MB"

  Scenario: Edit task
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Промяна"
    And I fill in the following:
      | Име:          | A-B problem                                        |
      | Time limit:   | 2                                                  |
      | Memory limit: | 1048576                                            |
    And I press "Обновяване"
    Then I should see "A-B problem"

  Scenario: Upload files
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Качване на файлове"
    And I attach the file at "test/fixtures/archive.zip" to "tests_file"
    And I press "Качване"
    Then I should see "test.in00"
    And I should see "test.in01"
    And I should see "test.ans00"
    And I should see "test.ans01"

  Scenario: Purge files files
    Given I am on the contest list in the admin panel
    And I follow "Задачи" within ".post"
    And I follow "Качване на файлове"
    And I attach the file at "test/fixtures/archive.zip" to "tests_file"
    And I press "Качване"
    And I follow "Изтриване на всички файлове"
    Then I should not see "test.in00"
    And I should not see "test.in01"
    And I should not see "test.ans00"
    And I should not see "test.ans01"

  Scenario: Add task to a category
    Given I am on the contest list in the admin panel
    And there is a category with attributes:
      | name | Динамично |
    When I follow "Задачи" within ".post"
    And I follow "Промяна"
    And I check "Динамично"
    And I press "Обновяване"
    And I am on the categories list in the admin panel
    And I follow "Динамично"
    Then I should see "A+B problem"
