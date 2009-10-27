Spoj0 for students
==================

Description
-----------

The idea of this project is to provide a grading system for high school students informatics competitions in [IOI][IOI] style.

The system contains two main components:
 * web part
 * grader
 
The web part is a rails app contained in the students folder.

The grader is a simple ruby class, which compiles the programs with g++ and runs them using a ruby runner, which observes the resources they use. The runner is runner.rb

Installation and usage
----------------------

Follow these steps:

* Go into students folder and run

  rake db:drop db:create db:migrate
   
* Run the rails app from the students folder with

  ./script/server
   
The admin user is with login "root" and password "" (empty string)

In order to grade the solutions, run

  rake grader:start
  
in the students folder.

[IOI]: http://olympiads.win.tue.nl/ioi/
