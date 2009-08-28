Latest Changes:
* Rename spoj to spoj0
* -Add mysql-client to apt-get in the install script
* +Add server time to all web pages
* +Add utf8 to all web pages
* +Add news functionallity.
* +Add description.pl to display problem descriptions
* +Hide the contests which are not started yet
* +Enable judging java
* -Redirect log info from global log to local logs
* -Show log on compilation error
* -Add special user flag - whose submits are not visible in the board
* -Add paths and stuff to the main module instead of hardcoding
* -Make spoj-import to make test submits
* -Fix the show_sources problem
* +Add news.pl to display news and notifications
* +sets.pl to display sets in reversed order


Problems for tommorow:
* E from the last contest
* C from the SP practice
* Gogov 
* unique number count

Pronounced 'споджо'
Stancho and Pancho Online Judge Oh
Sofia Public Onlune Judge Zero
Stand Proud Online Judge Zero
Student Panic Online Judge 0
Stop Playing Other Junk 0utside

== Intro ==

* The problem names are always A, B, C, ...
* Only acm grading style

== Components ==

=== WEB ===


==== submit.pl ====

run form:
	username:
	password:
	contest-id:
	language:
	source:
	
	
==== status.php ====

the status of the submits

arguments:
	

==== board.php ====




=== directory tree ===

sets
	<set-code>
		[set-info.conf -- future, for automatic import of a set]
		<problem-letter>
			test.in -- input data
			test.ans -- the correct answer
			[solution-<something>.{c,cpp,java}]
			[problem-info.conf -- future]
			[checker -- future]
			
			

	
=== DB ===

users
	name
	password
	display-name
	comment
	
<pre>
CREATE TABLE  `spoj`.`users` (
  `user_id` int(11) NOT NULL auto_increment,
  `name` char(16) NOT NULL COMMENT 'the username (for login)',
  `pass_md5` char(64) NOT NULL,
  `display_name` char(64) NOT NULL COMMENT 'Full name (ex: coaches - Manev, Sredkov, Bogdanov)',
  `about` text NOT NULL COMMENT 'about the user',
  PRIMARY KEY  (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User accounts (may be teams also)'
</pre>
	
	
contest
	contest_id -- int (primary key)
	set_code -- the contest short name (like fmi-2007-03-04)
	name -- full name (like "Вътрешна тренировка на fmi")
	start_time -- from what time the contest will be visible
	duration -- how long will it be in minutes (usually 300)
	show_sources (bool - whether to show sources '''after''' the contest)
	

<pre>
CREATE TABLE  `spoj`.`contests` (
  `contest_id` int(11) NOT NULL auto_increment,
  `set_code` char(64) NOT NULL COMMENT 'the contest short name (like fmi-2007-03-04)',
  `name` char(128) NOT NULL comment 'full name (like "Вътрешна тренировка на fmi")',
  `start_time` datetime NOT NULL COMMENT 'from what time the contest will be visible',
  `duration` int not null comment 'how long will it be in minutes (usually 300)',
  `show_sources` bit not null comment 'whether to show the source after the contest',
  `about` text not null comment 'information about the contest',
  PRIMARY KEY  (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User accounts (may be teams also)'

</pre>

runs
	run_id -- int (primary key)
	problem_id -- fk
	user_id -- fk
	language (java, cpp ...)
	source-code -- the whole source code
	source-name -- the name of the source file (may be needed for java, or may be autodetected)
	status (waiting, judging,
	 
	
<pre>
CREATE TABLE  `spoj`.`runs` (
  `run_id` int(11) NOT NULL auto_increment,
  `problem_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `language` char(16) NOT NULL COMMENT 'java, cpp ...',
  `source_code` mediumtext NOT NULL COMMENT 'the whole source code',
  `source_name` char(32) NOT NULL COMMENT 'may be needed for java, or may be autodetected',
  `about` text NOT NULL COMMENT 'notes about the code may be present',
  `status` char(16) NOT NULL COMMENT 'waiting, judging, ok, wa... ',
  `log` text NOT NULL COMMENT 'execution details',
  PRIMARY KEY  (`run_id`),
  KEY `fk_problems` (`problem_id`),
  KEY `fk_users` (`user_id`),
  CONSTRAINT `fk_problems` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`problem_id`),
  CONSTRAINT `fk_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
</pre>

	
	 

problems 
	problem_id -- pk
	contest_id -- fk
	letter -- the problem letter. must correspond to its directory
	name -- the full name of the problem
	time_limit -- the time limit in seconds
	about -- notes about the problem
	[checker -- future (diff, float(precision), etc)]
	[memory_limit] -- future

<pre>

CREATE TABLE  `spoj`.`problems` (
  `problem_id` int(11) NOT NULL auto_increment,
  `contest_id` int(11) NOT NULL,
  `letter` char(16) NOT NULL COMMENT 'The problem letter. Must correspond to its directory.',
  `name` char(64) NOT NULL COMMENT 'the full name of the problem',
  `time_limit` int(11) NOT NULL COMMENT 'the time limit in seconds',
  `about` text NOT NULL COMMENT 'notes about the problem',
  PRIMARY KEY  (`problem_id`),
  KEY `new_fk_constraint` (`contest_id`),
  CONSTRAINT `new_fk_constraint` FOREIGN KEY (`contest_id`) REFERENCES `contests` (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
</pre>

=== spoj-deamon ===

* Running as a deamon.
* Checks for unjudged runs.
** Find a run, mark as judging.
** Test it, write the result.
* logs many things in a big log file

=== spoj-grade ===

* invoked as: spoj-grade <source-name> <lang> <time-limit> <input> <answer>
* stdout contains the status (ok, wa, ce, ...)
* stderr (or other log) contains 

=== Tools ===

* spoj-import -- to automaticaly import 
* spoj-rejudge -- to redjudge a run, or many runs
* spoj-submit -- to maual submit a solution





== Required stuff ==

* mysql
* timeout (debian package)
* launchtool - cool!
* apache-mod-perl!




