The students should be able to participate in timed contests. The contests have 
a start time, end time and duration. When a student opens a contest the timer
starts and the student can submit solutions for the given duration.

Story: Submit solution
    In order to submit a solution
    As a student
    I want to be able to submit solutions
    
    Scenario: Open a running contest
        Given there is a logged student with login "Valo" and password "secret"
        And there is a running contest named "Test contest"
        And the contest "Test contest" has a task named "Task"
        When I go to the homepage
        And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
        Then I should see "Прати решение"
        And I should see "Task"
        
    Scenario: Submit a solution to a running contest
        Given there is a logged student with login "Valo" and password "secret"
        And there is a running contest named "Test contest"
        And the contest "Test contest" has a task named "Task"
        When I go to the homepage
        And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
        When I fill in the following:
          | Задача:   | Таск       |
          | Език:     | C/C++ |
          | Сорс код: | printf("Hello")   |
