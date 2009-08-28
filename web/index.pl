#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;

print header(-charset=>'utf-8'),
	start_html($NAME),
	WebNavMenu,
	h1($NAME),
	qq^
		<p>
			This is the minimalistic online judge named <strong>$NAME</strong>.
			Use the menu on top to navigate.
		</p>
		
		<p>
			Currently most of the things are manual. To register an account contact the 
			administrator.
		</p>
		<p>
			Стига сте джиткали с тестовите потребители. Който иска да се включи, 
			да ми прати потребителско име, парола, пълно име, и about (учебно заведение, 
			fn ако е от фми или каквото друго прецени). Всички състезания са отворени за 
			всички регистрирани.
		</p>
		<p>
			Гледайте и пишете в <a 
				href="http://judge.openfmi.net/wiki/index.php/Spoj0"
			>http://judge.openfmi.net/wiki/index.php/Spoj0</a> за разни хубави неща...
				
		</p>
	^;
	
print end_html;

