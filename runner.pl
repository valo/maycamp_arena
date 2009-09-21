#!/usr/bin/perl
use POSIX;
use Getopt::Long;
use BSD::Resource;

if(@ARGV == 0) {
  print "Usage: runner.pl <options> <command>\n";
  print "Options: \n";
  print "  --mem <bytes> - The amount of memory allowed in bytes\n";
  print "  --time <seconds> - The amount of CPU time allowed in seconds\n";
  print "  --procs <processes> - The number of processes allowed during the execution of the command\n";
  print "  --files <files> - The number of allowed open files\n";
  print "  --user <username> - The user with which to execute the command\n";
  print "  --root <path_to_root> - A directory in which to chroot the command\n";
  exit 0;
}

GetOptions("mem:i"   => \$mem,
           "time:i"  => \$time,
           "procs:i" => \$procs,
           "files:i" => \$files,
           "user:s"  => \$user,
           "root:s"  => \$root);
           
setrlimit(RLIMIT_VMEM, $mem, $mem) or die "Cannot set VMEM limit" if $mem;
setrlimit(RLIMIT_NPROC, $procs, $procs) or die "Cannot set NPROC limit" if $procs;
setrlimit(RLIMIT_OFILE, $files, $files) or die "Cannot set OFILE limit" if $files;
setrlimit(RLIMIT_CPU, $time, $time) or die "Cannot set CPU limit" if $time;

chroot($root) or die "Cannot chroot to $root" if $root;

$> = getpwnam($user) if $user;

if ($pid = fork) {
  if($time) {
    $SIG{ALRM} = sub { kill 'KILL', $pid };
    alarm 5 * $time;
  }

  waitpid($pid, 0);
  kill 'KILL', -$pid;
  
  exit($? & 127);
} else {
  setpgrp(0, $$) or die "Cannot create a process group with id $$";
  exec @ARGV;
}
