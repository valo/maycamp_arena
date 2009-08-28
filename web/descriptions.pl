#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html4/;

my $problem_id = param('problem_id');

my $dbh = &SqlConnect;
my $prob = (GetProblemsEx $dbh, {'id'=>param('problem_id')})->[0];
my $prefix = $$prob{'c_code'}."-";

my $pd = $$prob{'p_dir'};
my $cd = $$prob{'c_dir'};

#TODO: always the first desciption is returned. There should be way to select from multiple
my $fn = '';
my $path = '';
WebError("Contest not started yet!") if(!$$prob{'c_active'});

#warn "pd=$pd, cd=$pd";

my @files = DirFiles $pd;
for my $f(@files){
	#warn "f=$f";
	if($f  =~ /^description.*/){
		$fn = $f;
		$path = "$pd/$fn";
		$prefix .= $$prob{'letter'}."-";
		last;
	}
}
if(!$fn){
	#look for a global desription file
	my @files = DirFiles $cd;
	for my $f(@files){
		#warn "f=$f";
		if($f  =~ /^description.*/){
			$fn = $f;
			$path = "$cd/$fn";
			last;
		}
	}
}

if($fn){
	print header(-type=>'application/x-download', -attachment=>$prefix.$fn);
	print ReadFile($path);
}
else{
	WebError "Can not locate description\n";
}
