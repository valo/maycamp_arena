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