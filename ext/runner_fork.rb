#!/usr/bin/env ruby
# Runs a process with some resource limitations
# Spacial status codes:
# 127 - memory limit
# 15 - time limit
require File.dirname(__FILE__) + "/runner_args.rb"
require 'rprocfs'

class ExecuteCommand
  def initialize(opt)
    @used_memory = 0
    @used_time = 0
    @opt = opt
  end

  def call
    pid = fork_command

    if !pid
      puts "Cannot start the child process! #{$!}"
      exit 1
    end

    sleep(initial_sleep)

    monitor_process(pid)
  end
  private
    attr_reader :used_time, :used_memory, :opt, :start_time

    def fork_command
      @start_time = Time.now
      fork do
        # Process.setrlimit(Process::RLIMIT_CPU, timelimit, timelimit) if timelimit
        Process.setrlimit(Process::RLIMIT_NPROC, opt.proclimit, opt.proclimit) if opt.proclimit
        Process.setpriority(Process::PRIO_PROCESS, 0, 10)

        # Set the process group of the child to its pid. This way it can be easily killed
        # with all its child processes later
        Process.setpgid(0, Process.pid)

        # Close the stderr, because we don't need it
        $stderr.close

        # FIXME: the user change is not working right now
        # Process::UID.change_privilege(Etc.getpwnam(user).uid) if user
        $stdin.reopen(File.open(opt.input, "r"))
        $stdout.reopen(File.open(opt.output, "w"))
        Kernel.exec "#{opt.cmd}"
      end
    end

    def monitor_process(pid)
      loop do
        @used_memory = [used_memory, memory_for_pgid(Process.getpgid(pid))].max
        @used_time = time_for_pgid(Process.getpgid(pid))

        if opt.mem && used_memory > opt.mem
          kill_pgid(Process.getpgid(pid))
          return 127
        end

        if opt.timelimit && (used_time > opt.timelimit || process_stale?(pid))
          kill_pgid(Process.getpgid(pid))
          return 9
        end

        status = Process.wait(pid, Process::WNOHANG)
        if status
          print_stats
          return($?.exitstatus || $?.termsig || $?.stopsig)
        end

        sleep 0.01
      end
    end

    def initial_sleep
      0.01
    end

    def process_group_pids(pgid)
      %x{ps -xo "%r %p" | egrep "^\s*#{pgid}" | awk '{print $2}'}.lines.map(&:to_i)
    end

    def time_for_pid(pid)
      [:utime, :stime, :cutime, :cstime].map { |m| RProcFS.send(m, pid) }.inject(0) { |a, sum| a + sum }
    rescue Errno::ENOENT
      0
    end

    def memory_for_pid(pid)
      RProcFS.resident(pid)
    rescue Errno::ENOENT
      0
    end

    def memory_for_pgid(pgid)
      sum(process_group_pids(pgid).map { |pid| memory_for_pid(pid) })
    end

    def time_for_pgid(pgid)
      sum(process_group_pids(pgid).map { |pid| time_for_pid(pid) })
    end

    def sum(numbers)
      numbers.inject(0) { |sum, a| sum + a }
    end

    def kill_pgid(pgid)
      Process.kill "KILL", -pgid
      Process.waitall
      print_stats
    end

    def time_since_run
      Time.now - start_time
    end

    def process_stale?(pid)
      RProcFS.state(pid) == "S" && time_since_run > (opt.timelimit + 2) # Wait 2 seconds more so that we are sure the process is stalled
    end

    def print_stats
      $stderr.puts "Used time: #{used_time}"
      $stderr.puts "Used mem: #{used_memory}"
    end
end

opt = Options.new

exit ExecuteCommand.new(opt).call

