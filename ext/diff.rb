#!/usr/bin/env ruby

IO.popen("diff --strip-trailing-cr #{ARGV.join(" ")}") do |diff|
  if output = diff.read(512)
    puts output
  end
  while diff.read(512) do
  end
end

exit $?.exitstatus
