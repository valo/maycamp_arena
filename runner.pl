#!/usr/bin/perl
use Getopt::Long;
use BSD::Resource;

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

chroot $root or die "Cannot chroot to $root" if $root;

if($#ARGV == 0) {
  print "Usage: runner.pl <options> <command>";
  print "Options: ";
  print "  --mem <bytes> - The amount of memory allowed in bytes";
  print "  --time <seconds> - The amount of CPU time allowed in seconds";
  print "  --procs <processes> - The number of processes allowed during the execution of the command";
  print "  --files <files> - The number of allowed open files";
  print "  --user <username> - The user with which to execute the command";
  print "  --root <path_to_root> - A directory in which to chroot the command";
  exit 0;
}

exec @ARGV