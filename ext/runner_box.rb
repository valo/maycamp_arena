#!/usr/bin/env ruby
# Runs a process with some resource limitations
# Spacial status codes:
# 127 - memory limit
# 9 - time limit
require 'rubygems'
require 'open3'
require 'getoptlong'
require 'etc'

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--mem', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--time', '-t', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--procs', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--input', '-i', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--output', '-o', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--user', '-u', GetoptLong::OPTIONAL_ARGUMENT ]
    )

mem = nil
timelimit = nil
proclimit = nil
user = nil
input, output = nil, nil
opts.each do |opt, value|
  case opt
    when '--mem' then mem = value.to_i
    when '--time' then timelimit = value.to_f
    when '--procs' then proclimit = value.to_i
    when '--user' then user = value
    when '--input' then input = value
    when '--output' then output = value
  end
end

if ARGV.length < 1
  puts "No command specified to run!"
  exit 1
end

cmd = ARGV.shift
box = File.expand_path(File.dirname(__FILE__) + "/box-#{RUBY_PLATFORM}")
%x{#{box} -ff -T -t #{timelimit} -w #{10 * timelimit} -m #{mem / 1024.0} -M stat -a 0 -i #{input} -o #{output} -- #{cmd}}
status = File.read("stat").lines.inject({}) { |h, l| k, v = l.strip.split(":"); h[k] = v; h; }

$stderr.puts "Used time: #{status["time"]}"

memory_limit = status["status"] == "SG"
File.open(output, "r") do |f|
  f.each_line do |line|
    memory_limit ||= line =~ /Out of memory/
    break;
  end
end

if memory_limit
  $stderr.puts "Used mem: #{mem}"
else
  $stderr.puts "Used mem: #{status["mem"]}" 
end

exit 9 if status["status"] == "TO"
exit 127 if memory_limit
exit $?.exitstatus
