The students should be able to participate in timed contests. The contests have 
a start time, end time and duration. When a student opens a contest the timer
starts and the student can submit solutions for the given duration.

Story: Submit solution
    In order to submit a solution
    As a student
    I want to be able to submit solutions
    
    Scenario: Open a running contest
        Given there is a user with attributes:
          | login                 | valo                      |
          | name                  | Valentin Mihov            |
          | email                 | valentin.mihov@gmail.com  |
          | password              | secret                    |
        And there is a running contest named "Test contest"
        And the contest "Test contest" has a task named "Task"
        When I am on the login page
        And I fill in the following:
          | login                 | valo                      |
          | password              | secret                    |
        And I press "Влез"
        And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
        Then I should see "Изпрати решение"
        And I should see "Task"
        
    Scenario: Submit a solution to a running contest
        Given there is a user with attributes:
          | login                 | valo                      |
          | name                  | Valentin Mihov            |
          | email                 | valentin.mihov@gmail.com  |
          | password              | secret                    |
        And there is a running contest named "Test contest"
        And the contest "Test contest" has a task named "Task"
        When I am on the login page
        And I fill in the following:
          | login                 | valo                      |
          | password              | secret                    |
        And I press "Влез"
        And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
        When I fill in the following:
          | problem_id   | Таск       |
          | language     | C/C++ |
          | source_code | printf("Hello")   |
        And I press "Изпрати"
        Then I should see "waiting"