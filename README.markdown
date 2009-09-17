Spoj0 for students
==================

Description
-----------

The idea of this project is to provide a grading system for high school students informatics competitions in [IOI][IOI] style.

The system contains two main components:
 * web part
 * grader
 
The web part is a rails app contained in the students folder.

The grader is written in the spoj* perl scripts.

Installation and usage
----------------------

Follow these steps:

* Run the spoj0-install.sh script, which is going to create some new users and mysql databases.

* Go into students folder and run

  rake db:drop db:create db:migrate
   
* Run the rails app with

  ./start/server
   
The admin user is with login "root" and password "123123"

In order to grade the solutions, run ./spoj0-control start-here as root.

[IOI]: http://olympiads.win.tue.nl/ioi/

TODO
----

Currently there is one grader implemented in perl. The idea is to completely replace it, because there is too much SQL inside and this doesn't fit well with the Rails ORM classes.

I implemented a runner.pl script, which can be used to run an executable in a sandbox. Also a Grader class for grading solutions completely in Ruby. This should be enough as infrastructure.

To be done:
1. More tests for the runner.pl script, so we can be sure that the grader could not be crashed or exploited
2. Improve the Grader class to recognize exist statuses for memory limit exceeded and time limit exceeded.
3. Measure the used resources by the graded solutions

Far future:
1. Make pluggable compilers for different languages
2. Make pluggable testers for different types of problems
