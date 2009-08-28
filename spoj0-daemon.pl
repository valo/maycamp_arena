#!/usr/bin/perl

use lib "/home/spoj0/";
use strict;
use DBI;
use spoj0;

chdir $HOME_DIR;
close STDOUT;
open STDOUT, '>>daemon.log';
close STDERR;
open STERR, '>>daemon.err';


my $now = SqlNow();
print STDOUT "= deamon run $now =\n";
print STDERR "= deamon run $now =\n";

my $pid = getppid;
System "echo '$pid' > /var/run/spoj0.pid";


my $dbh = SqlConnect;

my $WAITING = 'waiting';
my $OK = 'ok';
#my $WAITING = 'ok';
#my $OK = 'waiting';




my $stop_file = $STOP_DAEMON_FILE;

sub Grade{
	my $run = shift or die; #hash ref
	
	my $run_id = $$run{'run_id'};
	return (System "perl spoj0-grade.pl $run_id >$EXEC_DIR/grade.log 2>$EXEC_DIR/grade.err") == 0;
	
}


print "Beware.... spoj0-deamon running!";

while(!-f $stop_file){
	my $sql = "SELECT run_id, status FROM runs WHERE status='$WAITING' LIMIT 1";
	my $st = $dbh->prepare($sql);
	$st->execute() or die "Unable to execute $sql : $!";
	my $hash_ref = $st->fetchrow_hashref;
	$st->finish;
	#warn;
	if(defined($hash_ref)){
		my $run_id = $$hash_ref{'run_id'};
		#mark as judging
		my $update_st = $dbh->prepare(
			"UPDATE runs SET status='judging' WHERE run_id=? AND status='$WAITING'");
		#warn;
		$update_st->bind_param(1, $run_id);
		my $affected = $update_st->execute;
		$update_st->finish;
		if($affected == 1){
			#ok, we marked it...
			print "marked run $run_id for judging.\n";
			
			#my $status = $OK; #do nothing for now
			#my $log = 'fake judged';
			
			my $status = Grade $hash_ref;
			
			if($status){
				print "Done with $run_id\n";
			}
			else {
				print "Problem grading $run_id\n";
			}
				
		}
		else{
			warn "Affected $affected. Another deamon?";
		}
	}
	else{
		print ".\n";
	}
	sleep 1;
	
}

print "Stopped by the presence of $stop_file\n";
System "rm /var/run/spoj0.pid";