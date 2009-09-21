#!/usr/bin/perl
use BSD::Resource;

local $SIG{ALRM} = sub { die "Timeout!" };
alarm 2;
if ($pid = fork) {
  waitpid($pid, 0);
  $usage = getrusage(RUSAGE_SELF);
  print "Time used: ".$usage->stime."\n";
  print "Mem used: ".$usage->idrss + $usage->isrss."\n";
} else {
  exec @ARGV;
}
