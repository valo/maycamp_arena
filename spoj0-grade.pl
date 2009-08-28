#!/usr/bin/perl

use strict;
use DBI;
use spoj0;

# should be invoked with a signle agrument - the run_id
# does not check the status, so may be used to redjudge


#close STDOUT;
#open STDOUT, '>$EXEC_DIR/grade.log';
#close STDERR;
#open STERR, '>$EXEC_DIR/grade.err';


my $run_id = shift or die;


my $dbh = SqlConnect;

my $run_st = $dbh->prepare("SELECT * FROM runs WHERE run_id=?");
$run_st->bind_param(1, $run_id);
$run_st->execute() or die "Unable to execute statment : $!";
my $run = $run_st->fetchrow_hashref;
$run_st->finish;

my $problem_st = $dbh->prepare(	"SELECT * from problems where problem_id=?");
$problem_st->bind_param(1, $$run{'problem_id'});
$problem_st->execute() or die "Unable to execute statment : $!";
my $problem = $problem_st->fetchrow_hashref;
$problem_st->finish;

my $contest_st = $dbh->prepare(	"SELECT * from contests where contest_id=?");
$contest_st->bind_param(1, $$problem{'contest_id'});
$contest_st->execute() or die "Unable to execute statment : $!";
my $contest = $contest_st->fetchrow_hashref;
$contest_st->finish;


#some paths:
#my $ex = '/home/spojrun';
#my $sets = './sets';

#System "rm $EXEC_DIR/grade.log";
System "echo '==== Run $run_id ===='";


#chdir "./execute" or die "unable to chdir to execute";

#cleanup
System "rm $EXEC_DIR/program";
System "rm $EXEC_DIR/program.cpp";
System "rm $EXEC_DIR/test.in";
System "rm $EXEC_DIR/test.out";
System "rm $EXEC_DIR/run.log";
System "rm $EXEC_DIR/run.err";
#System "rm $EXEC_DIR/grade.log";
#System "rm $EXEC_DIR/grade.err";
System "rm $EXEC_DIR/*.class";
System "rm $EXEC_DIR/*.java";

sub JavaMain{
#TODO: limitation - only one top level class, default package
	$$run{'source_name'} =~ /^(.+)\.java$/ or die "What source name!?";
	return $1;
}

my $status = 'ok';
my $lang = $$run{'language'};
my $java_main = '';
if($lang eq 'cpp'){
	WriteFile "$EXEC_DIR/program.cpp", $$run{'source_code'};

	System "g++ -O2 $EXEC_DIR/program.cpp -o $EXEC_DIR/program ";
	$status = 'ce' if(not -f "$EXEC_DIR/program");

}
elsif($lang eq 'java'){
	$java_main = JavaMain;
	WriteFile "$EXEC_DIR/$java_main.java", $$run{'source_code'};

	System "javac $EXEC_DIR/$java_main.java ";
	$status = 'ce' if(not -f "$EXEC_DIR/$java_main.class");
}
else{
	die "Unsupported language $lang!";
}


#dont do it for now
#System 'rm $EXEC_DIR/*'; 

#-- ! making

if($status eq 'ok'){ #run
	chdir($EXEC_DIR);
	
	#copy input
	my $in_path = "$SETS_DIR/".$$contest{'set_code'}."/".$$problem{'letter'}."/test.in";
	System "cp '$in_path' '$EXEC_DIR/test.in'";
	
	my $time = $$problem{'time_limit'};
	++$time if $lang eq 'java';
	#-- ! executing
	
	my $exec = '';
	if($lang eq 'cpp'){
		$exec = "$EXEC_DIR/program";
	}
	elsif($lang eq 'java'){
		$exec = "java -cp . $java_main";
	}
	else{
		die "Unsupported language $lang!";
	}
	
	my $run = "time timeout $time $exec < $EXEC_DIR/test.in >$EXEC_DIR/test.out 2>>$EXEC_DIR/run.err";
	
	my $megarun = "launchtool --tag=spoj0-grade --limit-process-count=30 "
		."--limit-open-files=60 --user=spoj0run '$run'";
	
	my $exit = System $megarun;
	warn $exit;
	if($exit == 35072){
		#killed - timeout
		$status = 'tl';
	}
	elsif($exit != 0 || -s "$EXEC_DIR/run.err"){
		$status = 're';
	}
}

if($status eq 'ok'){ #check
	my $ans_path = "$SETS_DIR/".$$contest{'set_code'}."/".$$problem{'letter'}."/test.ans";
	my $exit = System "diff $EXEC_DIR/test.out $ans_path";
	#warn $exit;
	if($exit != 0){
		$exit = System "diff -w $EXEC_DIR/test.out $ans_path";
		if($exit == 0) {
			$status = 'pe';
		}
		else{
			$status = 'wa';
		}
	}
}

my $log = "=== GRADE ===\n";
$log .= ReadFile("$EXEC_DIR/grade.log");
$log .= "=== GRADE ERR ===\n";
$log .= ReadFile("$EXEC_DIR/grade.err");
#$log .= "=== RUN ===\n";
#$log .= ReadFile "$ex/run.log";
$log .= "=== RUN ERR ===\n";
$log .= ReadFile("$EXEC_DIR/run.err");


my $final_st = $dbh->prepare("UPDATE runs SET status=?, log=? WHERE run_id=?");
$final_st->bind_param(1, $status);
$final_st->bind_param(2, $log);
$final_st->bind_param(3, $run_id);
$final_st->execute;
print "Done with $run_id, status $status.\n"
