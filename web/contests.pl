#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;



my $dbh = &SqlConnect;

sub print_conts{

	my @rows = (th([
		'id',
		'code', 
		'name',
		'start', 
		'duration', 
		'status',
		'action']),);

	my $conts = GetContestsEx $dbh, {
		'active' => 0,
		'reverse' => 1,
	};
	foreach my $cont(@$conts){
		my $view_link = "contests.pl?contest_id=".$$cont{'contest_id'};
		my $board_link = "board.pl?contest_id=".$$cont{'contest_id'};
		push @rows, td([
			$$cont{'contest_id'},
			$$cont{'set_code'},
			$$cont{'name'},
			$$cont{'start_time'},
			$$cont{'duration'},
			$$cont{'c_status'},
			qq(<a href="$view_link">view</a> <a href="$board_link">board</a>)
		])
	}
	
	print table(
		{'-border'=>1},
        caption(strong('Contests')),
        Tr({-align=>'center',-valign=>'top'}, \@rows)
    );
}


sub print_cont{
	my $id = shift or die;
	
	my $cont_st = $dbh->prepare(qq( 
		SELECT * FROM contests WHERE contest_id=?
	));
	$cont_st->execute($id) or die "Unable to execute statment!";
	my $cont = $cont_st->fetchrow_hashref;
	$cont_st->finish;
	
	my $cont = (GetContestsEx $dbh, {'id'=>$id})->[0];
	print h3("id"), $$cont{'contest_id'};
	print h3("code"), $$cont{'set_code'};
	print h3("name"), $$cont{'name'};
	print h3("start_time"), $$cont{'start_time'};
	print h3("duration"), $$cont{'duration'};
	print h3("status"), $$cont{'status'};
	print h3("about"), $$cont{'about'};	
	print br,br;
	
    
	my @rows = (th([
		'id',
		'letter',
		'name', 
		'about',
		'action']),
	);

	my $prob_st = $dbh->prepare(qq( 
		SELECT * FROM problems WHERE contest_id=?
	));
	$prob_st->execute($id) or die "Unable to execute statment!";
	my $prob;
	
	my @probs = GetProblemsEx $dbh, {'contest_id'=>$id};
	
	while($prob = $prob_st->fetchrow_hashref){
		my $submit_link = "submit.pl?problem_id=".$$prob{'problem_id'};
		my $runs_link = "status.pl?problem_id=".$$prob{'problem_id'};
		my $desc_link = "descriptions.pl?problem_id=".$$prob{'problem_id'};
		push @rows, td([
			$$prob{'problem_id'},
			$$prob{'letter'},
			$$prob{'name'},
			$$prob{'about'},
			qq(<a href="$submit_link">submit</a> 
				<a href="$runs_link">runs</a> 
				<a href="$desc_link">description</a>
			)
		])
	}
	$prob_st->finish;
	
	print table(
		{'-border'=>1},
        h3('Problems'),
        Tr({-align=>'center',-valign=>'top'}, \@rows)
    );
	

}

my $title = "Contests";

print header(-charset=>'utf-8'),
	start_html($title),
	WebNavMenu,
	h1($title);
	
if(param('contest_id')){
	print_cont param('contest_id');
}
else{
	print_conts;
}

	
print end_html;


