#!/usr/bin/perl
use BSD::Resource;

local $SIG{ALRM} = sub { die "Timeout!" };
alarm 2;
if ($pid = fork) {
  wait;
  alarm 0;
  $usage = getrusage(RUSAGE_CHILDREN);
  print "Time used: ".$usage->stime."\n";
  print "Mem used: ".$usage->maxrss."\n";
} else {
  exec @ARGV;
}
