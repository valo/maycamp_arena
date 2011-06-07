#!/usr/bin/env ruby
# Runs a process with some resource limitations
# Spacial status codes:
# 127 - memory limit
# 15 - time limit
require 'rubygems'
require 'rprocfs'
require 'getoptlong'
require 'etc'

def print_stats(used_mem, used_time)
  $stderr.puts "Used time: #{used_time}"
  $stderr.puts "Used mem: #{used_mem}"
end

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--mem', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--time', '-t', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--procs', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--user', '-u', GetoptLong::OPTIONAL_ARGUMENT ]
    )

mem = nil
timelimit = nil
proclimit = nil
user = nil
opts.each do |opt, value|
  case opt
    when '--mem' then mem = value.to_i
    when '--time' then timelimit = value.to_f
    when '--procs' then proclimit = value.to_i
    when '--user' then user = value
  end
end

if ARGV.length < 1
  puts "No command specified to run!"
  exit 1
end

cmd = ARGV.shift

pid = fork do
  # Process.setrlimit(Process::RLIMIT_CPU, timelimit, timelimit) if timelimit
  Process.setrlimit(Process::RLIMIT_NPROC, proclimit, proclimit) if proclimit
  Process.setpriority(Process::PRIO_PROCESS, 0, 20)
  
  # Close the stderr, because we don't need it
  $stderr.close
  
  # FIXME: the user change is not working right now
  # Process::UID.change_privilege(Etc.getpwnam(user).uid) if user
  Kernel.exec cmd
end

if !pid
  puts "Cannot start the child process! #{$!}"
  exit 1
end

sleep([timelimit / 2, 0.1].min) if timelimit

used_memory = used_time = 0
loop {
  used_memory = [used_memory, RProcFS.data(pid)].max
  used_time = [:utime, :stime, :cutime, :cstime].map { |m| RProcFS.send(m, pid) }.inject(0) { |a, sum| a + sum }
  
  if mem and RProcFS.data(pid) > mem
    Process.kill "KILL", pid
    Process.waitall
    print_stats(used_memory, used_time)
    exit 127
  end
  
  if timelimit and (RProcFS.state(pid) == "S" or used_time > timelimit)
    Process.kill "KILL", pid
    Process.waitall
    print_stats(used_memory, used_time)
    exit 9
  end
  
  status = Process.wait(pid, Process::WNOHANG)
  if status
    print_stats(used_memory, used_time)
    exit($?.exitstatus || $?.termsig || $?.stopsig)
  end
  
  sleep 0.001
}

