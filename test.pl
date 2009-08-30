#!/usr/bin/perl
use strict;
use Time::localtime;
use DBI;
# use spoj;

# my $dbh = SqlConnect;
# 
# warn $dbh->quote("Don't\""), " -- should be quoted correctly";

my $test = 'ls';
foreach (`$test`) {
  print $_;
}

my $str = 'This is a test';
$str =~ s/(test)/$1er/;
print $str."\n";

sub test_func {
  # print "This is a test func\n";
  return "a", "b";
}

my ($a, $b) = test_func;

print $a, $b;
