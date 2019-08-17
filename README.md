# Maycamp Arena

--------------

## Status

[![Gemnasium Status](https://gemnasium.com/valo/maycamp_arena.png)](https://gemnasium.com/valo/maycamp_arena)
[![Travis CI Status](https://travis-ci.org/valo/maycamp_arena.svg?branch=master)](https://travis-ci.org/valo/maycamp_arena)

------------------

## Table of Contents
- [Maycamp Arena](#maycamp-arena)
	- [Status](#status)
	- [Table of Contents](#table-of-contents)
	- [Description](#description)
	- [Features](#features)
	- [Installation](#installation)
		- [Dependencies](#dependencies)
			- [General](#general)
			- [Additional](#additional)
		- [Setup](#setup)
			- [Web part](#web-part)
		- [Grader](#grader)
		- [Running the tests](#running-the-tests)
		- [Access](#access)
	- [Deployment](#deployment)

------------------

## Description

The idea of this project is to provide a grading system
for competitions in informatics ([IOI][IOI] style).
The main target group is high school students.

The system contains two main components:

* Web part
* Grader

The *web part* is a Ruby on Rails application,
contained in the app folder.

The *grader* [compiles](https://github.com/valo/maycamp_arena/blob/0923c323a6026ff9a440991141b177c6eed1c481/app/services/grade_run.rb#L43)
the source code and [runs](https://github.com/valo/maycamp_arena/blob/0923c323a6026ff9a440991141b177c6eed1c481/app/services/grade_run.rb#L66)
the binary inside multiple [docker](https://www.docker.com/)
containers and feeds each one with the given test cases.
It monitors the consumption of the system resources - time limit, memory limit, etc..

[Go back](#table-of-contents)

-----------------

## Features

* Participation in live contests.
* Practicing old contests.
* Grouping contests by categories.
* Grouping problems by categories.
* Evaluation of regular [input/output tasks](https://github.com/valo/maycamp_arena/wiki/Format-of-the-tasks#regular-inputoutput-tasks)
* Answer evaluation using [checker](https://github.com/valo/maycamp_arena/wiki/Format-of-the-tasks#tasks-with-checkers)
* Supported programming languages:
 * C/C++
 * Java
 * Python 2 & 3
* Possibility for integrating more than one grader on different machines.

[Go back](#table-of-contents)

---------------

## Installation

The following steps describe how to run the project
on a local environment for **developing** purposes.
The best and fastest way to get the project up and running
is to use the already configured Vagrant virtual development
environment.

### Dependencies

#### General
* Git
* MySQL Server 5.5+ or MariaDB is preferred
* Ruby 2.1+ (the easiest way is to use RVM or rbenv)

#### Additional
(for the virtual environment)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
or other VM provider.
* [Ansible](https://github.com/ansible/ansible)



### Setup

#### Web part
Download the project and initialize the virtual environment.
```bash
$ git clone https://github.com/valo/maycamp_arena.git
$ cd maycamp_arena
$ vagrant up
```
This last command may take a while to execute, considering
the fact that the proper virtual box binary
must be downloaded and provisioned.  

Configure the ruby version. Keep in mind that `rvm` is already installed on the virtual machine.

**NB!** vm is just a placeholder for vagrant@vagrant-ubuntu-trusty64

```bash
$ vagrant ssh
vm$ rvm install 2.1.1
vm$ rvm use 2.1.1
vm$ cd /vagrant
```

Install the MySQL server. *It is recommended to leave the root user without password (blank password), otherwise you should change the configurations*.
```bash
vm$ sudo apt-get install mysql-server
```

Install the package dependencies and run the database migrations with:
```bash
vm$ bundle install
vm$ bundle exec rake db:create db:setup
```
After you have successfully completed the installation process
of the web application you can start the server with:
```bash
$vm /vagrant/bin/rails server -b 0.0.0.0
```
and access it in your browser on `localhost:3030`.

### Grader

Getting the grader up and running is done with:

```bash
vm$ cd /vagrant
vm$ gem install god
vm$ docker build -t grader .
vm$ printf "vagrant-ubuntu-trusty-64:\n rsync: /vagrant/sets" > config/grader.yml
```

and running it with:
```bash
vm$ /home/vagrant/.rvm/bin/rvm 2.1 do bundle exec rake RAILS_ENV=production grader:start
```

### Running the tests

To run the tests execute:

```bash
$ bundle exec cucumber
```

### Access
After you have successfully set up the project you can log in
with the dummy admin account:
```
username: root
password: 123123
```
[Go back](#table-of-contents)

[IOI]: http://olympiads.win.tue.nl/ioi/
[Install]: https://github.com/valo/maycamp_arena/wiki/Installation


## Deployment

Deployment is done using docker stack. Follow these steps:

- Provision a machine with docker
- Checkout the code of the repository in `/app`. This is **important** as the location of the app in the deployment should be the same as on the host machine.
- Init docker swarm by running `docker swarm init`
- Generate new SECRET_KEY_BASE and SECRET_TOKEN and put them in docker-compose.yaml. Use `openssl rand --hex 64` to generate the secrets
- Change the SIDEKIQ_USERNAME and SIDEKIQ_PASSWORD to something more secure
- Set the mailgun key and domain so that the system can send emails
- Generate the docker image used for grading by running `docker build -f grader.Dockerfile -t grader .`
- Run `docker stack deploy maycamp --compose-file docker-compose.yaml` to deploy the app
- Find the ID of the `maycamp_web` container by running `docker ps` and init the DB `docker exec <container_id> rake db:setup`

The app should be accessible from the IP address of the provisioned machine. By default it binds on port 80.

**WARNING:** The current deployment has some limitations:

* It runs only on a single node clusters. This is because it uses shared volumes to communicate between the different services
* It requires to checkout the code in the `/app` folder on the host machine. This is because the grader service connects directly to the docker host server and spawns the grading containers with volumes mounted to the host machine. Once the communication between the container based on volumes is removed, this limitation will be removed.