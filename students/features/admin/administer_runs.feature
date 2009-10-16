Story: Administer runs
  In order to be able to control the system
  As a administrator
  I want to be able to administer the runs

  @admin @runs
  Scenario: Submitting a run
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
    