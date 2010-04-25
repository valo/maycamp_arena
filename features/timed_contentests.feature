@timed_contests
Feature: Submit solution
  In order to submit a solution
  As a student
  I want to be able to submit solutions
  
  Background:
    Given there is a user with attributes:
      | login                 | valo                      |
      | name                  | Valentin Mihov            |
      | email                 | valentin.mihov@gmail.com  |
      | password              | secret                    |
    And there is a running contest named "Test contest"
    And the contest "Test contest" has a task named "Task"
    And I am on the login page
    And I fill in the following:
      | login                 | valo                      |
      | password              | secret                    |
    And I press "Влез"
  
  Scenario: Open a running contest
    Given I am on the homepage
    When I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
    Then I should see "Изпрати решение"
    And I should see "Task"
      
  Scenario: Submit a solution to a running contest
    Given I am on the homepage
    And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
    When I select "C/C++" from "run_language"
    And I select "Task" from "run_problem_id"
    And I fill in "#include <stdio.h>" for "run_source_code"
    And I press "Изпрати"
    Then I should see "checking"
    And I should see "Виж сорс кода"

  Scenario: Submit a solution to a running contest with a source file
    Given I am on the homepage
    And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
    When I select "C/C++" from "run_language"
    And I select "Task" from "run_problem_id"
    And I attach the file at "test/fixtures/source_code.c" to "Качи решение:"
    And I press "Изпрати"
    Then I should see "checking"
    And I should see "Виж сорс кода"

  Scenario: View source code
    Given I am on the homepage
    And I follow "ЗАПОЧНИ СЪСТЕЗАНИЕТО!"
    When I select "C/C++" from "run_language"
    And I select "Task" from "run_problem_id"
    And I fill in "#include <stdio.h>" for "run_source_code"
    And I press "Изпрати"
    And I follow "Виж сорс кода"
    Then I should see "#include <stdio.h>"
