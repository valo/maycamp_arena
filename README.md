# Spoj0 for students

## Status

[![Gemnasium Status](https://gemnasium.com/valo/maycamp_arena.png)](https://gemnasium.com/valo/maycamp_arena)
[![Travis CI Status](https://travis-ci.org/valo/maycamp_arena.png)](https://travis-ci.org/valo/maycamp_arena)

## Description

The idea of this project is to provide a grading system for high school students informatics competitions in [IOI][IOI] style.

The system contains two main components:

* web part
* grader

The web part is a rails app contained in the students folder.

The grader is a simple ruby class, which compiles the programs with g++ and runs them using a ruby runner, which observes the resources they use. The runner is runner.rb

## Installation

### Dependencies

* Git
* MySQL Server (5.5+ or MariaDB is preferred)
* Ruby 2.1+ (the easiest way is to use RVM or rbenv)

### How to install and setup

It is recommended to use RVM, as it won't require you root permissions. You need to first [install](https://rvm.io/rvm/install) RVM and then you need ruby 2.1.1:

```bash
$ rvm install 2.1.1
$ rvm use 2.1.1
```

Run this:

```bash
$ git clone https://github.com/valo/maycamp_arena.git
$ bundle install
$ bundle exec rake db:create db:setup
$ bundle exec rails server
```

This is going to checkout the code, install all the dependecies, setup your database and run the server locally.

### Running the tests

The tests are run with:

```bash
$ bundle exec cucumber
```

[IOI]: http://olympiads.win.tue.nl/ioi/
[Install]: https://github.com/valo/maycamp_arena/wiki/Installation
