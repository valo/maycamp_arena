The students should be able to register on the website and login after that.

Story: Register a user
  In order to be able to login
  As a student
  I want to be able to register
  
  Scenario: Register a new user
    Given I am not logged in
    When I am on the signup page
    And I fill in the following:
      | Потребителско име:         | valo                      |
      | Истинско име:              | Valentin Mihov            |
      | Email:                     | valentin.mihov@gmail.com  |
      | Парола:                    | secret                    |
      | Потвърди паролата:         | secret                    |
    And I press "Създай нов потребител"
    Then I should see "Благодаря за регистрацията."
    And I should see "Valentin Mihov (Изход)"
  
  Scenario: Register a new user
    Given I am not logged in
    When I am on the signup page
    And I fill in the following:
      | Потребителско име:         | valo                      |
      | Истинско име:              | Valentin Mihov            |
      | Email:                     | valentin.mihov@gmail.com  |
    And I press "Създай нов потребител"
    Then I should see "полета:Паролата не може да е без стойност"

  Scenario: Login existing user
    Given there is a user with attributes:
      | login                             | valo                     |
      | name                              | Valentin Mihov           |
      | email                             | valentin.mihov@gmail.com |
      | unencrypted_password              | secret                   |
      | unencrypted_password_confirmation | secret                   |
    And I am not logged in
    When I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"
    Then I should see "Valentin Mihov (Изход)"
    
    Scenario: Logout logged user
      Given there is a user with attributes:
      | login                             | valo                     |
      | name                              | Valentin Mihov           |
      | email                             | valentin.mihov@gmail.com |
      | unencrypted_password              | secret                   |
      | unencrypted_password_confirmation | secret                   |
      And I am not logged in
      When I am on the login page
      And I fill in the following:
        | login                 | valo                      |
        | password              | secret                    |
      And I press "Влез"
      And I follow "Valentin Mihov (Изход)"
      Then I should not see "Valentin Mihov (Изход)"
      And I should see "Не сте влезли в системата"