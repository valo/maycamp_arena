Story: Administer tasks
  In order to be able to control the system
  As a administrator
  I want to be able to administer the tasks

  @admin @problems
  Scenario: Create new task
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Описание: | An example contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име: | A+B problem |
      | Описание: | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1 |
    And I press "Създаване"
    Then I should be on the problem list in the admin panel
    And I should see "A+B problem"

  @admin @problems
  Scenario: Delete task
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Описание: | An example contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име: | A+B problem |
      | Описание: | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1 |
    And I press "Създаване"
    And I follow "Изтриване"
    Then I should be on the problem list in the admin panel
    And I should not see "A+B problem"

  @admin @problems
  Scenario: View task
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име: | Fall contest |
      | Описание: | An example contest |
      | Продължителност: | 120 |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име: | A+B problem |
      | Описание: | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1 |
    And I press "Създаване"
    And I follow "Преглед"
    Then I should see "Име: A+B problem"
    And I should see "Описание: Прочетете от входа 2 числа и изведете сборът им"
    And I should see "Time limit: 1 sec"
    And I should see "Memory limit: 16 MB"

  @admin @problems
  Scenario: Edit task
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име:              | Fall contest       |
      | Описание:         | An example contest |
      | Продължителност:  | 120                |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име:        | A+B problem                                     |
      | Описание:   | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1                                               |
    And I press "Създаване"
    And I follow "Промяна"
    And I fill in the following:
      | Име:          | A-B problem                                        |
      | Описание:     | Прочетете от входа 2 числа и изведете разликата им |
      | Time limit:   | 2                                                  |
      | Memory limit: | 1048576                                            |
    And I press "Обновяване"
    Then I should see "A-B problem"

  @admin @problems
  Scenario: Upload files
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име:              | Fall contest       |
      | Описание:         | An example contest |
      | Продължителност:  | 120                |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име:        | A+B problem                                     |
      | Описание:   | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1                                               |
    And I press "Създаване"
    And I follow "Качване на файлове"
    And I attach the file at "test/fixtures/archive.zip" to "tests_file"
    And I press "Качване"
    Then I should see "test.in00"
    And I should see "test.in01"
    And I should see "test.ans00"
    And I should see "test.ans01"

  @admin @problems
  Scenario: Purge files files
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
    And I follow "Ново състезание"
    And I fill in the following:
      | Име:              | Fall contest       |
      | Описание:         | An example contest |
      | Продължителност:  | 120                |
    And I select "October 16, 2009 16:21:39" as the "Начало:" date
    And I select "October 18, 2009 16:21:39" as the "Край:" date
    And I press "Създаване"
    And I follow "Задачи"
    And I follow "Нова задача"
    And I fill in the following:
      | Име:        | A+B problem                                     |
      | Описание:   | Прочетете от входа 2 числа и изведете сборът им |
      | Time limit: | 1                                               |
    And I press "Създаване"
    And I follow "Качване на файлове"
    And I attach the file at "test/fixtures/archive.zip" to "tests_file"
    And I press "Качване"
    And I follow "Изтриване на всички файлове"
    Then I should not see "test.in00"
    And I should not see "test.in01"
    And I should not see "test.ans00"
    And I should not see "test.ans01"
