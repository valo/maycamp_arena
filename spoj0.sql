CREATE DATABASE IF NOT EXISTS spoj0;
USE spoj0;


-- TODO: another user should be added also with less privileges!
GRANT ALL PRIVILEGES ON spoj0.* TO 'spoj0_admin'@'localhost'
IDENTIFIED BY 'stancho3' WITH GRANT OPTION;

--
-- Table structure for table `contests`
--

DROP TABLE IF EXISTS `runs`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `problems`;
DROP TABLE IF EXISTS `contests`;


DROP TABLE IF EXISTS `contests`;
CREATE TABLE `contests` (
  `contest_id` int(11) NOT NULL auto_increment,
  `set_code` char(64) NOT NULL COMMENT 'the contest short name (like fmi-2007-03-04)',
  `name` char(128) NOT NULL COMMENT 'full name (like "Вътрешна тренировка на fmi")',
  `start_time` datetime NOT NULL COMMENT 'from what time the contest will be visible',
  `duration` int(11) NOT NULL COMMENT 'how long will it be in minutes (usually 300)',
  `show_sources` int(11) NOT NULL COMMENT 'whether to show the source after the contest',
  `about` text NOT NULL COMMENT 'information about the contest',
  PRIMARY KEY  (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User accounts (may be teams also)';

--
-- Table structure for table `problems`
--

DROP TABLE IF EXISTS `problems`;
CREATE TABLE `problems` (
  `problem_id` int(11) NOT NULL auto_increment,
  `contest_id` int(11) NOT NULL,
  `letter` char(16) NOT NULL COMMENT 'The problem letter. Must correspond to its directory.',
  `name` char(64) NOT NULL COMMENT 'the full name of the problem',
  `time_limit` int(11) NOT NULL COMMENT 'the time limit in seconds',
  `about` text NOT NULL COMMENT 'notes about the problem',
  PRIMARY KEY  (`problem_id`),
  KEY `new_fk_constraint` (`contest_id`),
  CONSTRAINT `new_fk_constraint` FOREIGN KEY (`contest_id`) REFERENCES `contests` (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `problems`
--

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL auto_increment,
  `name` char(16) NOT NULL COMMENT 'the username (for login)',
  `pass_md5` char(64) NOT NULL,
  `display_name` char(64) NOT NULL COMMENT 'Full name (ex: coaches - Manev, Sredkov, Bogdanov)',
  `about` text NOT NULL COMMENT 'about the user',
  `hidden` int(11) NOT NULL default 0 COMMENT 'whether the submits of this user does not show come in the board',
  PRIMARY KEY  (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User accounts (may be teams also)';

-- users 1..9 are test users

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES (1,'test1',MD5('change-me'),'Test 1','test user', 1);
INSERT INTO `users` VALUES (2,'test2',MD5('p2-guess'),'Test 2','test user', 0);
INSERT INTO `users` VALUES (3,'test3',MD5('p3-guess'),'Test 3','test user', 0);
INSERT INTO `users` VALUES (4,'test4',MD5('p4-guess'),'Test 4','test user', 0);
INSERT INTO `users` VALUES (5,'test5',MD5('p5-guess'),'Test 5','test user', 0);
INSERT INTO `users` VALUES (6,'test6',MD5('p6-guess'),'Test 6','test user', 0);
INSERT INTO `users` VALUES (7,'test7',MD5('p7-guess'),'Test 7','test user', 0);
INSERT INTO `users` VALUES (8,'test8',MD5('p8-guess'),'Test 8','test user', 0);
INSERT INTO `users` VALUES (9,'test9',MD5('p9-guess'),'Test 9','test user', 0);
INSERT INTO `users` VALUES (10,'milo','83e4a96aed96436c621b9809e258b309','Milo Sredkov','coach', 0);
UNLOCK TABLES;


--
-- Table structure for table `runs`
--

DROP TABLE IF EXISTS `runs`;
CREATE TABLE `runs` (
  `run_id` int(11) NOT NULL auto_increment,
  `problem_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `submit_time` datetime NOT NULL COMMENT 'when the run is submited',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `runs`
--


--
-- Table structure for table `runs`
--

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `new_id` int(11) NOT NULL auto_increment,
  `new_time` datetime NOT NULL COMMENT 'when the new is submited',
  `file` char(64) NOT NULL COMMENT 'the file that the new came from',
  `topic` char(128) NOT NULL COMMENT 'the title of the new',
  `content` text NOT NULL COMMENT 'the new contents',
  PRIMARY KEY  (`new_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

