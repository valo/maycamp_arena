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

exec @ARGV