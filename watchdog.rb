#!/usr/bin/env ruby
pid = fork do
  Kernel.exec ARGV.join(" ")
end

peak_mem = 0
shared_mem = 0
begin
  size, resident, share, text, lib, data, dt = `cat /proc/#{pid}/statm`.split(/\s+/)
  new_mem = size.to_i
  peak_mem = new_mem if new_mem > peak_mem
  shared_mem = share.to_i if share.to_i > shared_mem
  sleep 0.1
end while !Process.waitpid(pid, Process::WNOHANG)

puts "Peak memory: #{peak_mem * 4096}"
puts "Shared mem: #{shared_mem * 4096}"
#puts "Non-shared mem: #{(peak_mem - shared_mem) * 4096}"
