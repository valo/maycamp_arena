#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;



my $dbh = &SqlConnect;

sub PrintStatuses{

	my @rows = (th([
		'run_id', 
		'user',
		'contest', 
		'problem(id)', 
		'submit_time', 
		'language', 
		'about', 
		'status', 
		'action']),);

	my $limit = 100;
	$limit = 10000 if(param('all'));	
	my $run_st = $dbh->prepare(qq( 
		SELECT 
			r.run_id, 
			u.display_name as uname,
			c.set_code as ccode,
			p.letter as pletter,
			p.problem_id,
			r.submit_time, 
			r.language,
			r.about,
			r.status
		FROM runs as r 
		INNER JOIN users as u ON r.user_id = u.user_id
		INNER JOIN problems as p ON r.problem_id = p.problem_id
		INNER JOIN contests as c ON p.contest_id = c.contest_id
		ORDER BY r.run_id desc
		LIMIT $limit
	));
	$run_st->execute() or die "Unable to execute statment!";
	my $run;
	while($run = $run_st->fetchrow_hashref){
		my $run_id = $$run{'run_id'};
		push @rows, td([
			$$run{'run_id'},
			$$run{'uname'},
			$$run{'ccode'},
			$$run{'pletter'}." (".$$run{'problem_id'}.")",
			$$run{'submit_time'},
			$$run{'language'},
			$$run{'about'},
			$$run{'status'},
			qq(<a href="status.pl?run_id=$run_id">view</a>)
		])
	}
	$run_st->finish;
	
	print table(
		{'-border'=>1},
        caption(strong('Submits')),
        Tr({-align=>'center',-valign=>'top'}, \@rows)
    );
}

sub PrintStatus{
	my $run_id = shift or die;
	my $run_st = $dbh->prepare(qq( 
		SELECT 
			r.run_id, 
			r.submit_time, 
			r.language,
			r.about,
			r.status,
			r.source_code,
			r.log,
			u.display_name as u_name,
			c.name as c_name,
			p.letter as p_letter,
			p.name as p_name,
			c.show_sources,
			unix_timestamp(c.start_time) as c_start,
			unix_timestamp() as now_time,
			c.duration
		FROM runs as r 
		INNER JOIN users as u ON r.user_id = u.user_id
		INNER JOIN problems as p ON r.problem_id = p.problem_id
		INNER JOIN contests as c ON p.contest_id = c.contest_id
		HAVING r.run_id=?
	));
	$run_st->execute($run_id) or die "Unable to execute statment!";
	my $run = $run_st->fetchrow_hashref;
	
	print h3("Run Id"), $$run{'run_id'};
	print h3("Submit Time"), $$run{'submit_time'};
	print h3("Language"), $$run{'language'};
	print h3("About"), $$run{'about'};
	print h3("Status"), $$run{'status'};
	print h3("User"), $$run{'u_name'};
	print h3("Contest"), $$run{'c_name'};
	print h3("Problem"), $$run{'p_letter'}, " : ", $$run{'p_name'};
	
	if($$run{'show_sources'} == 1 && ($$run{'now_time'} - $$run{'c_start'}) / 60 > $$run{'duration'}){
		print h3("Source");
		print pre(escapeHTML($$run{'source_code'}));
		print h3("Log");
		print pre(escapeHTML($$run{'log'}));
	}
	elsif($$run{'status'} eq 'ce'){
		print h3("Log");
		print pre(escapeHTML($$run{'log'}));
	}
}



print header(-charset=>'utf-8'),
	start_html("Status"),
	WebNavMenu,
	h1("Status");

if(param('run_id')){
	PrintStatus param('run_id');
}
else {
	PrintStatuses;
}
	
print end_html;


