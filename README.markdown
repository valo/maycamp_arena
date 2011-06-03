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

Installation
----------------------

* First you must download the source on your local machine:
  
      # git clone git://github.com/valo/maycamp_arena.git
  
* Then set the correct user, home folder, server address that you are going to use. This is in config/deploy.rb:

      set :user, "contest"
      set :home_path, "/home/contest"

      role :web, "judge.openfmi.net"                          # Your HTTP server, Apache/etc

      role :app, "judge.openfmi.net"                          # This may be the same as your `Web` server

      role :db,  "judge.openfmi.net", :primary => true # This is where Rails migrations will run

The app is going to be deployed in /home/contest/maycamp with the example setup above

* Install the following packages on the machine you are going run the app (the remote machine):

      # apt-get install libreadline5-dev libxml2-dev libxslt-dev

* Install RVM for the user on the remote machine. Follow these instructions: [http://beginrescueend.com/rvm/install/][RVM]

* Install Ruby Enterprise Edition on the remote machine and make it the default ruby VM:

      # rvm install ree
      
      # rvm use ree --default
  
* Install bundler on the remote machine:

      # gem install bundler
  
* On your local machine run the following to setup the remote machine:
  
      # cap deploy:setup

* Fix the configuration of the app. All the configuration will be in /home/contest/maycamp/shared/config. You should fix at least /home/contest/maycamp/shared/config/database.yml and enter valid mysql config under the production section
  
* From your local machine deploy the app

      # cap deploy:update deploy:migrate deploy:start
  
The above command is going to download the source from github, install the required gems, migrate the DB and start the server. At this point you have app running on port 8000

* Start the grader:

      # nohup rake grader:start RAILS_ENV=production &

[IOI]: http://olympiads.win.tue.nl/ioi/
[RVM]: http://beginrescueend.com/rvm/install/
