#!/usr/bin/perl

use strict;
use Time::localtime;
use DBI;
use spoj0;

#usage - ./spoj0-control.pl <command> [<args>...]

my $spoj_dir = $HOME_DIR;

sub Usage{
	die qq(
Usage:
	$0 start 
		starts the deamon (needs root)
	$0 start-here
		starts the spoj0-daemon here (not as a daemon)
	$0 stop 
		stops the deamon (needs root)
	$0 kill 
		kills the deamon if it has blocked by some reason... 
		use with care (needs root)
	$0 rejudge-problem <problem_id> 
		marks all submits on the given problem for redjudge 
		except the accepted ones
	$0 rejudge-problem-all <problem_id>
		marks all submits on the given problem for redjudge 
		including the accepted ones
	$0 rejudge-run <run_id> 
		marks the given run for redjudge
	$0 sync-news <set_code>
		Synchronizes the news, by addding all new news form the 'news' directory to the database.
	$0 import-set <set_code>
		Imports given set into the system. Note that the set should already be in the 'sets' directory.
	$0 sync-set <set_code>
		Imports given set or updates its information if already present. Note that the set should already be in the 'sets' directory.
	
	$0 submit <problem_id> <user_id> <source_file> <language> [<about>]
		Submits given solution.
	)
}

my $cmd = shift @ARGV;

my $dbh = SqlConnect;

my $stop_file = $STOP_DAEMON_FILE;
my $run_tag = 'spojdm';


if($cmd eq 'start'){
	System "rm $stop_file";
	System "start-stop-daemon --start --pidfile /var/run/spoj0.pid -b --exec $spoj_dir/spoj0-daemon.pl";
	
	
	#System "launchtool --log-launchtool-output=file:launchtool.log --log-launchtool-errors=file:launchtool.err "
	#	." --debug --tag=$run_tag --no-pidfile -d './spoj-daemon.pl-b >daemon.log 2>daemon.err'";
	
}
elsif($cmd eq 'start-here'){
	System "rm $stop_file";
	System "./spoj0-daemon.pl";
	
	#System "launchtool --log-launchtool-output=file:launchtool.log --log-launchtool-errors=file:launchtool.err "
	#	." --debug --tag=$run_tag --no-pidfile -d './spoj-daemon.pl-b >daemon.log 2>daemon.err'";
	
}
elsif($cmd eq 'stop'){
	System "echo 'stop!' > $stop_file";
}
elsif($cmd eq 'kill'){
	System "echo 'stop!' > $stop_file";
	System "start-stop-daemon --stop --pidfile /var/run/spoj0.pid";
}
elsif($cmd eq 'rejudge-run'){
	my $run_id = shift @ARGV or Usage;
	my $res = $dbh->do(
		"UPDATE runs SET status='waiting' WHERE run_id=?", 
		undef, $run_id);
	print "Affected $res\n";
}
elsif($cmd eq 'rejudge-problem'){
	my $problem_id = shift @ARGV or Usage;
	my $res = $dbh->do(
		"UPDATE runs SET status='waiting' WHERE problem_id=? AND status<>'ok'", 
		undef, $problem_id);
	print "Affected $res\n";
}
elsif($cmd eq 'rejudge-problem-all'){
	my $problem_id = shift @ARGV or Usage;
	my $res = $dbh->do(
		"UPDATE runs SET status='waiting' WHERE problem_id=?", 
		undef, $problem_id);
	print "Affected $res\n";
}
elsif($cmd eq 'sync-news'){
	&SyncNews;
}
elsif($cmd eq 'import-set'){
	my $set_code = shift @ARGV or Usage;
	&ImportSet($set_code);
}
elsif($cmd eq 'sync-set'){
	my $set_code = shift @ARGV or Usage;
	&SyncSet($set_code);
}
elsif($cmd eq 'submit'){
	my $problem_id = shift @ARGV or Usage;
	my $user_id = shift @ARGV or Usage;
	my $source_fn = shift @ARGV or Usage;
	my $language = shift @ARGV or Usage;
	my $about = shift @ARGV;
	$about or $about = "submit by $0";
	&SubmitRun($problem_id, $user_id, $source_fn, $language, $about);
}
else{
	Usage;
}

sub SyncNews{
	my @new_files = DirFiles $NEWS_DIR;
	foreach my $nf(@new_files){
		if($nf =~ /.+\.new$/){
			next if (scalar @{GetNews $dbh, {'file'=>$nf}});
			my $file;
			open $file, "$NEWS_DIR/$nf";
			my $topic = <$file>;
			my $content = join('', <$file>);
			close $file;
			SqlInsert \$dbh, 'news', {
				'new_time' => SqlNow,
				'file' => $nf,
				'topic' => $topic,
				'content' => $content
			};
		}
	}
}

sub ImportSet{

	my $set_code = shift or die "pass the set code as argument";
	my $tm = localtime;
	
	my %set_data = (
		'set_code' => $set_code,
		'name' => "Unnamed",
		'start_time' => SqlNow,
		'duration' => 300,
		'show_sources' => '1',
		'about' => ''
	);
	
	my %problems = ();
	
	my $set_name = "Unnamed";
	
	ParseConf "$SETS_DIR/$set_code/set-info.conf", \%set_data;
	
	SqlInsert \$dbh, 'contests', \%set_data;
	
	my $contest_id = $dbh->last_insert_id(undef, 'spoj0', 'contests', 'contest_id');
	print "contest_id: $contest_id\n";
	
	my @pls = DirFiles "$SETS_DIR/$set_code";
	
	my $pl; #problem letter
	foreach my $pl(@pls){
		#warn $pl;
		if(!($pl =~ /^\..*/) && -d "$SETS_DIR/$set_code/$pl/"){
			#warn $pl;
			my %problem_data = (
				'contest_id' => $contest_id,
				'letter' => $pl,
				'name' => "Unnamed $pl",
				'time_limit' => 1,
				'about' => ""
			);
			ParseConf "$SETS_DIR/$set_code/$pl/problem-info.conf", \%problem_data;
			$problems{$pl} = \%problem_data; 
			DosToUnix "$SETS_DIR/$set_code/$pl/test.in";
			DosToUnix "$SETS_DIR/$set_code/$pl/test.ans";
		}
	}
	
	foreach my $letter(sort keys %problems){
		SqlInsert \$dbh, 'problems', $problems{$letter};
		my $problem_id = $dbh->last_insert_id(undef, 'spoj0', 'problems', 'problem_id');
		print "problem_id: $problem_id for: $letter\n";
		
		my $prob_dir = "$SETS_DIR/$set_code/$letter";
		my @prob_files = DirFiles "$prob_dir/";
		foreach my $pf(@prob_files){
			if($pf =~ /^solution.*/){
				&SubmitRun($problem_id, $TESTER_ID,  "$prob_dir/$pf");
			}
		}
	}
	
}

sub SyncSet{

	my $set_code = shift or die "pass the set code as argument";
	my $tm = localtime;
	
	my %set_data = (
		'set_code' => $set_code,
		'name' => "Unnamed",
		'start_time' => SqlNow,
		'duration' => 300,
		'show_sources' => '1',
		'about' => ''
	);
	
	my %problems = ();
	
	my $set_name = "Unnamed";
	
	ParseConf "$SETS_DIR/$set_code/set-info.conf", \%set_data;
	
	SqlSync $dbh, 'contests', \%set_data, ['set_code'];
	
	
	my $contest_id = (GetContestsEx $dbh, {'set_code'=>$set_code})->[0]->{'contest_id'};
	print "contest_id: $contest_id\n";
	
	my @pls = DirFiles "$SETS_DIR/$set_code";
	
	my $pl; #problem letter
	foreach my $pl(@pls){
		#warn $pl;
		if(!($pl =~ /^\..*/) && -d "$SETS_DIR/$set_code/$pl/"){
			#warn $pl;
			my %problem_data = (
				'contest_id' => $contest_id,
				'letter' => $pl,
				'name' => "Unnamed $pl",
				'time_limit' => 1,
				'about' => ""
			);
			ParseConf "$SETS_DIR/$set_code/$pl/problem-info.conf", \%problem_data;
			$problems{$pl} = \%problem_data; 
			DosToUnix "$SETS_DIR/$set_code/$pl/test.in";
			DosToUnix "$SETS_DIR/$set_code/$pl/test.ans";
		}
	}
	
	foreach my $letter(sort keys %problems){
		SqlSync $dbh, 'problems', $problems{$letter}, ['contest_id', 'letter'];
		my $problem_id = (GetProblemsEx $dbh, {'contest_id'=>$contest_id, 'letter'=>$letter})->[0]->{'problem_id'};

		print "problem_id: $problem_id for: $letter\n";
		
		my $prob_dir = "$SETS_DIR/$set_code/$letter";
		my @prob_files = DirFiles "$prob_dir/";
		foreach my $pf(@prob_files){
			if($pf =~ /^solution.*/){
				&SubmitRun($problem_id, $TESTER_ID,  "$prob_dir/$pf");
			}
		}
	}
	
}


sub SubmitRun{
	
	my $problem_id = shift or die;
	my $user_id = shift or die;
	my $source_fn = shift or die;
	my $language = shift;
	my $about = shift;
	$source_fn =~ m!^(.*/)?([^/]+)$!;
	my $source_name = $2;
	$source_name =~ m!.+\.([^.]+)$!;
	my $source_ext = $1;
	$language or $language = $source_ext;
	$about or $about = $source_name;
	my $source_code = ReadFile($source_fn);
	
	
	my %run_data = (
		'problem_id' => $problem_id,
		'user_id' => $user_id,
		'submit_time' => SqlNow(),
		'language' => $language,
		'source_code' => $source_code,
		'source_name' => $source_name,
		'about' => $about,
		'status' => 'waiting',
		'log' => ''
	);
	
	
	my $dbh = SqlConnect;
	
	$dbh or die "Unable to connect to database!";
	
	
	SqlInsert \$dbh, 'runs', \%run_data;
	print "run_id: ", $dbh->last_insert_id(undef, 'spoj0', 'runs', 'run_id'), "\n";
	

}