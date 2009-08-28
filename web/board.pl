#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;



my $dbh = &SqlConnect;


sub PrintBoard{
	my $contest_id = shift;
	my $online = shift; #whether only online submits will be counted
	
	my $contest = GetContestInfo \$dbh, $contest_id;

	if(!$contest) {
		print "Bad contest";
		return;
	}
	
	
	#get all runs related to the contest
	my $run_st = $dbh->prepare(qq(
		SELECT 
			r.run_id, 
			u.display_name as u_name,
			u.user_id,
			u.hidden as u_hidden,
			p.letter as p_letter,
			p.problem_id,
			c.contest_id,
			UNIX_TIMESTAMP(r.submit_time) as s_time,
			UNIX_TIMESTAMP(c.start_time) as c_time,
			c.duration,
			r.status
		FROM runs as r 
		INNER JOIN users as u ON r.user_id = u.user_id
		INNER JOIN problems as p ON r.problem_id = p.problem_id
		INNER JOIN contests as c ON p.contest_id = c.contest_id
		HAVING contest_id = ?
		ORDER BY r.run_id
	));
	$run_st->execute($contest_id);

	q!
		$user_stat{<user_id>}{<problem_id>}{'first_ok'} = minutes
		$user_stat{<user_id>}{<problem_id>}{'bad'} = bad attempts before first ok
		$user_stat{<user_id>}{'solved'} = number of accepted problems
		$user_stat{<user_id>}{'time'} = penalty
		$user_stat{<user_id>}{'submits'} = count
		$user_stat{<user_id>}{'name'} = display_name
		$user_stat{<user_id>}{'problems'} = display_name
		
		$problem_stat{<problem_id}{'accepts'}
		$problem_stat{<problem_id}{'submits'}
		$problem_stat{<problem_id}{'name'}
	!;
	
	my %user_stat = ();
	my %problem_stat = ();
	
	my $run;
	while($run = $run_st->fetchrow_hashref){
		my $status = $$run{'status'};
		my $contest_start = $$run{'c_time'};
		my $minutes = ($$run{'s_time'} - $contest_start) / 60;
		last if($online && $minutes > $$run{'duration'});
		next if($status eq 'waiting' || $status eq 'judging');
		next if($$run{'u_hidden'});
		my $user_id = $$run{'user_id'};
		my $problem_id = $$run{'problem_id'};
		next if(defined($user_stat{$user_id}{$problem_id}{'first_ok'}));
		
		#now we should count this submit
		$user_stat{$user_id}{'name'} = $$run{'u_name'};	
		++$user_stat{$user_id}{'submits'};
		
		$problem_stat{$problem_id}{'name'} = $$run{'p_letter'};
		++$problem_stat{$problem_id}{'submits'};
		
		if($status eq 'ok'){
			$user_stat{$user_id}{$problem_id}{'first_ok'} = $minutes;
			$user_stat{$user_id}{$problem_id}{'bad'} or 
				$user_stat{$user_id}{$problem_id}{'bad'} = 0;
			$user_stat{$user_id}{'time'} += 
				$minutes + 20 * $user_stat{$user_id}{$problem_id}{'bad'};
			++$user_stat{$user_id}{'problems'};
			++$problem_stat{$problem_id}{'accepts'};
		}
		else{
			++$user_stat{$user_id}{$problem_id}{'bad'};
		}
	}
	$run_st->finish;
	
	my @user_order = sort {
		$user_stat{$b}{'problems'} <=> $user_stat{$a}{'problems'}
		|| $user_stat{$a}{'time'} <=> $user_stat{$b}{'time'}
	} (keys %user_stat);
	
	my @problem_order = (); #sort keys %problem_stat;
	my $prob_head = "";
	
	my $problem_st = $dbh->prepare("SELECT * FROM problems WHERE contest_id=? ORDER BY problem_id");
	$problem_st->execute($contest_id);
	my $prob;
	while($prob = $problem_st->fetchrow_hashref){
		push @problem_order, $$prob{'problem_id'};
		$prob_head .= th($$prob{'letter'});
	}
	$problem_st->finish;
	
	my @rows = (th(['Rank', 'Name', 'Solved', 'Time']).$prob_head.th('Attempts'),);
	
	my $rank = 0;
	foreach my $user_id(@user_order){
		++$rank;
		my $row = "";
		$row .= td($rank)
			.td($user_stat{$user_id}{'name'})
			.td($user_stat{$user_id}{'problems'})
			.td(int($user_stat{$user_id}{'time'}));
		foreach my $problem_id(@problem_order){
			$row .= td(int($user_stat{$user_id}{$problem_id}{'first_ok'}).
				" (".$user_stat{$user_id}{$problem_id}{'bad'}.")");
			
		}
		$row .= td($user_stat{$user_id}{'submits'});
		push @rows, $row;
	}
	
	#TODO: add totals row!
	
	my $caption = $online ? "Online results for " : "Offline results for ";
	$caption .= i($$contest{'name'});
	
	print table(
		{'-border'=>1},
        h3($caption),
        Tr({-align=>'center',-valign=>'top'}, \@rows)
    );
	
}



my $title = "Board";

print header(-charset=>'utf-8'),
	start_html($title),
	WebNavMenu,
	h1($title);
	
if(param('contest_id')){
	PrintBoard param('contest_id'), 1;
	PrintBoard param('contest_id'), 0;
}
else{
	print strong(qq(Please select a <a href="contests.pl">contest</a>));
}

	
print end_html;

