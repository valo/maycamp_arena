#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;

my $LIMIT = 100;

my $dbh = &SqlConnect;


sub MakeField{
	my $key = shift or die;
	return td({-align=>'right'}, "$key:").
		td({-align=>'left'}, textfield(-name=>$key, -default=>param($key)||"", -size=>8));
	
}


sub PrintStatuses{

	my @rows = (th([
		'run_id', 
		'user(id)',
		'contest(id)', 
		'problem(id)', 
		'submit_time', 
		'lang', 
		'about', 
		'status', 
		'action']),);

	my $limit = $LIMIT;
	$limit = 10000 if(param('all'));	
	
	my $filter = " 1=1 ";
	$filter .= " AND user_id=".$dbh->quote(param('user_id')) if param('user_id');
	$filter .= " AND problem_id=".$dbh->quote(param('problem_id')) if param('problem_id');
	$filter .= " AND contest_id=".$dbh->quote(param('contest_id')) if param('contest_id');
	$filter .= " AND run_id<=".$dbh->quote(param('to_run_id')) if param('to_run_id');
	
	my $run_st = $dbh->prepare(qq( 
		SELECT 
			r.run_id, 
			r.user_id,
			r.problem_id,
			u.display_name as uname,
			c.set_code as ccode,
			p.letter as pletter,
			c.contest_id,
			r.submit_time, 
			r.language,
			r.about,
			r.status
		FROM runs as r 
		INNER JOIN users as u ON r.user_id = u.user_id
		INNER JOIN problems as p ON r.problem_id = p.problem_id
		INNER JOIN contests as c ON p.contest_id = c.contest_id
		HAVING $filter
		ORDER BY r.run_id desc
		LIMIT $limit
	));
	$run_st->execute() or die "Unable to execute statment!";
	my $run;
	while($run = $run_st->fetchrow_hashref){
		my $run_id = $$run{'run_id'};
		push @rows, td([
			$$run{'run_id'},
			$$run{'uname'}.'('.$$run{'user_id'}.')',
			$$run{'ccode'}.'('.$$run{'contest_id'}.')',
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
    my $count = scalar(@rows) - 1;
    print p("$count results");
    print p("*Note that at most $LIMIT results are shown!");
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

print 
	start_form(-method=>'GET'),
	table(
		{'-border'=>0},
		undef,
		Tr({-align=>'center'}, [
			td(b("Filters:")).
			MakeField('user_id').
			MakeField('problem_id').
			MakeField('contest_id').
			MakeField('to_run_id').
			td({-align=>'center'}, submit(-label=>'Show')).
				td({-align=>'left'}, "")
		]
		)
	),
	end_form;


if(param('run_id')){
	PrintStatus param('run_id');
}
else {
	PrintStatuses;
}
	
print end_html;


