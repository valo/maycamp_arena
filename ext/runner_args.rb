require 'rubygems'
require 'open3'
require 'getoptlong'
require 'etc'

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--mem', '-m', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--time', '-t', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--procs', '-p', GetoptLong::OPTIONAL_ARGUMENT ],
      [ '--input', '-i', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--output', '-o', GetoptLong::REQUIRED_ARGUMENT ],
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
