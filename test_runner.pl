#!/usr/bin/perl

foreach(glob("test/*.c*")) {
  s/\.c.*$//;
  system 'g++ $_.cpp -o $_'
  
  system 'perl runner.pl --mem 32768 --time 1 --procs 0 --files 0'
}