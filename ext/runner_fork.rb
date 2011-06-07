#!/usr/bin/env ruby
# Runs a process with some resource limitations
# Spacial status codes:
# 127 - memory limit
# 15 - time limit
require File.dirname(__FILE__) + "/runner_args.rb"

def print_stats(used_mem, used_time)
  $stderr.puts "Used time: #{used_time}"
  $stderr.puts "Used mem: #{used_mem}"
end

opt = Options.new

pid = fork do
  # Process.setrlimit(Process::RLIMIT_CPU, timelimit, timelimit) if timelimit
  Process.setrlimit(Process::RLIMIT_NPROC, opt.proclimit, opt.proclimit) if opt.proclimit
  Process.setpriority(Process::PRIO_PROCESS, 0, 20)
  
  # Close the stderr, because we don't need it
  $stderr.close
  
  # FIXME: the user change is not working right now
  # Process::UID.change_privilege(Etc.getpwnam(user).uid) if user
  $stdin.reopen(File.open(input, "r"))
  $stdout.reopen(File.open(output, "w"))
  Kernel.exec "#{opt.cmd}"
end

if !pid
  puts "Cannot start the child process! #{$!}"
  exit 1
end

sleep([top.timelimit / 2, 0.1].min) if opt.timelimit

used_memory = used_time = 0
loop {
  used_memory = [used_memory, RProcFS.data(pid)].max
  used_time = [:utime, :stime, :cutime, :cstime].map { |m| RProcFS.send(m, pid) }.inject(0) { |a, sum| a + sum }
  
  if opt.mem and RProcFS.data(pid) > opt.mem
    Process.kill "KILL", pid
    Process.waitall
    print_stats(used_memory, used_time)
    exit 127
  end
  
  if opt.timelimit and (RProcFS.state(pid) == "S" or used_time > opt.timelimit)
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

