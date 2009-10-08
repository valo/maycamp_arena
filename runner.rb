#!/usr/bin/env ruby
# Runs a process with some resource limitations
# Spacial status codes:
# 127 - memory limit
# 15 - time limit
require 'getoptlong'
require 'etc'

PAGE_SIZE = 4092

def total_runtime(pid)
  # stats = File.read("/proc/#{pid}/stat").chomp.split(/\s+/)
  # stats[13].to_i + stat
  t = Process.times
  t.utime + t.stime
end

def process_state(pid)
  File.read("/proc/#{pid}/stat").chomp.split(/\s+/)[2]
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
    when '--time' then timelimit = value.to_i
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
  Process.setrlimit(Process::RLIMIT_CPU, timelimit, timelimit) if timelimit
  Process.setrlimit(Process::RLIMIT_NPROC, proclimit, proclimit) if proclimit
  Process.setpriority(Process::PRIO_PROCESS, 0, 20)
  
  # FIXME: the user change is not working right now
  # Process::UID.change_privilege(Etc.getpwnam(user).uid) if user
  Kernel.exec cmd
end

if !pid
  puts "Cannot start the child process! #{$!}"
  exit 1
end

loop {
  data_size = File.read("/proc/#{pid}/statm").chomp.split(/\s+/)[5]
  
  if mem and data_size.to_i * PAGE_SIZE > mem
    Process.kill "KILL", pid
    Process.waitall
    exit 127
  end
  
  if timelimit and process_state(pid) == "S"
    Process.kill "KILL", pid
    Process.waitall
    exit 9
  end
  
  status = Process.wait(pid, Process::WNOHANG)
  exit($?.exitstatus || $?.termsig || $?.stopsig) if status
  
  sleep 0.001
}

