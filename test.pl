#!/usr/bin/perl

use strict;
use Time::localtime;
use DBI;
use spoj;

my $dbh = SqlConnect;

warn $dbh->quote("Don't\""), " -- should be quoted correctly";