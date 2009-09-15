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

my $run_st = $dbh->prepare("SELECT * FROM runs WHERE id=?");
$run_st->bind_param(1, $run_id);
$run_st->execute() or die "Unable to execute statment : $!";
my $run = $run_st->fetchrow_hashref;
$run_st->finish;

my $problem_st = $dbh->prepare( "SELECT * from problems where id=?");
$problem_st->bind_param(1, $$run{'problem_id'});
$problem_st->execute() or die "Unable to execute statment : $!";
my $problem = $problem_st->fetchrow_hashref;
$problem_st->finish;

my $contest_st = $dbh->prepare( "SELECT * from contests where id=?");
$contest_st->bind_param(1, $$problem{'contest_id'});
$contest_st->execute() or die "Unable to execute statment : $!";
my $contest = $contest_st->fetchrow_hashref;
$contest_st->finish;

sub do_run {
  my $in_path = shift;
  my $ans_path = shift;
  my $status = 'ok';

  print "Running test with input file $in_path and output file $ans_path";
  
  #copy input
  System "cp '$in_path' '$EXEC_DIR/test.in'";

  my $time = $$problem{'time_limit'};
  #-- ! executing

  my $exec = "$EXEC_DIR/program";

  my $run = "ulimit -t $time -v 1024 -u 1 -n 3 && $exec < $EXEC_DIR/test.in >$EXEC_DIR/test.out 2>>$EXEC_DIR/run.err";

  my $megarun = "launchtool --tag=spoj0-grade "
    ."--user=spoj0run --no-stats '$run'";

  my $exit = System $megarun;
  warn $exit;
  if($exit == 35072){
    #killed - timeout
    $status = 'tl';
  }
  elsif($exit != 0){
    $status = 're';
  }

  if($status eq 'ok'){ #check
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
  
  return $status, $log;
}


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

my $log = "";
my $status = 'ok';
my $lang = $$run{'language'};
my $java_main = '';
if($lang eq 'cpp' || $lang eq 'C/C++'){
  WriteFile "$EXEC_DIR/program.cpp", $$run{'source_code'};

  System "g++ -O2 $EXEC_DIR/program.cpp -o $EXEC_DIR/program ";
  $status = 'ce' if(not -f "$EXEC_DIR/program");

}
# Valo: disabling java for now. For the students competitions we won't need it
# elsif($lang eq 'java'){
#   $java_main = JavaMain;
#   WriteFile "$EXEC_DIR/$java_main.java", $$run{'source_code'};
# 
#   System "javac $EXEC_DIR/$java_main.java ";
#   $status = 'ce' if(not -f "$EXEC_DIR/$java_main.class");
# }
else{
  $log .= "Unsupported language $lang!\n";
  $status = 'ce';
}


#dont do it for now
#System 'rm $EXEC_DIR/*'; 

#-- ! making

# FIXME: valo: here we should change the grader to perform several runs with each
# input file that is passed. After that the status will contain a description of
# the runs. Something in the form: OK OK OK WA TL RE OK OK
# There will be another tool for parsing the statuses and ouputing the final
# results
if($status eq 'ok'){ #run
  chdir($EXEC_DIR);
  
  # for each input file, run the program and return the status
  my $name = lc($$problem{'name'});
  $name =~ s/\s+/_/g;
  my $in_path = "$SETS_DIR/".$$contest{'set_code'}."/".$name."/test.in*";
  $status = "";
  foreach (`ls $in_path`) {
    my $in_file = $_;
    chomp $in_file;
    my $out_file = $in_file;
    $out_file =~ s/in([0-9]*)$/ans$1/;
    
    my ($stat, $run_log) = do_run($in_file, $out_file);
    $status .= $stat." ";
    $log .= $run_log;
  }
}


my $final_st = $dbh->prepare("UPDATE runs SET status=?, log=? WHERE id=?");
$final_st->bind_param(1, $status);
$final_st->bind_param(2, $log);
$final_st->bind_param(3, $run_id);
$final_st->execute;
print "Done with $run_id, status $status.\n"
