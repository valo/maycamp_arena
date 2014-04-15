Spoj0 for students
==================

Status
------

[![Gemnasium Status](https://gemnasium.com/valo/maycamp_arena.png)](https://gemnasium.com/valo/maycamp_arena)
[![Travis CI Status](https://travis-ci.org/valo/maycamp_arena.png)](https://travis-ci.org/valo/maycamp_arena)

Description
-----------

The idea of this project is to provide a grading system for high school students informatics competitions in [IOI][IOI] style.

The system contains two main components:

* web part
* grader

The web part is a rails app contained in the students folder.

The grader is a simple ruby class, which compiles the programs with g++ and runs them using a ruby runner, which observes the resources they use. The runner is runner.rb

Installation
----------------------

There is an automatic installation script, which works for debian based systems. You can read more about it here: [https://github.com/valo/maycamp_arena/wiki/Installation][Install]. It is still WIP, so be patient until it is ready. It should provide a one command deploy for the system, so that you can get started in seconds.

[IOI]: http://olympiads.win.tue.nl/ioi/
[Install]: https://github.com/valo/maycamp_arena/wiki/Installation
