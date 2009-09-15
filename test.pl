#!/usr/bin/perl
use BSD::Resource;

setrlimit(RLIMIT_VMEM, 1024, 1024) or die "Cannot set VMEM limit";
setrlimit(RLIMIT_NPROC, 1, 1) or die "Cannot set NPROC limit";
setrlimit(RLIMIT_OFILE, 1, 1) or die "Cannot set OFILE limit";
setrlimit(RLIMIT_CPU, 1, 1) or die "Cannot set CPU limit";

exec 'wc -l'
