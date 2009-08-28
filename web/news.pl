#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;



my $dbh = &SqlConnect;
my $title = "News";

print header(-charset=>'utf-8'),
	start_html($title),
	WebNavMenu,
	h1($title);
	
my $news = GetNews $dbh;
foreach my $new(@$news){
	print h3($$new{'topic'}." @ ".$$new{'new_time'}),
		$$new{'content'}, hr;
}
	
print end_html;

