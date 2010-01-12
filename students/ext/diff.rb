#!/usr/bin/env ruby

IO.popen("diff --strip-trailing-cr #{ARGV[0]} #{ARGV[1]}") do |diff|
  if output = diff.read(512)
    puts output
  end
end

exit $?
