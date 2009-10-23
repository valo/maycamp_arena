Factory.define :user do |u|
  u.email "valentin.mihov@gmail.com"
  u.unencrypted_password "secret"
  u.unencrypted_password_confirmation "secret"
  u.admin false
  u.name "Valentin Mihov"
end

Factory.define :contest do |c|
  c.about "Some bogus text"
  c.duration 120
  c.start_time 1.hour.ago
  c.end_time 1.hour.from_now
end

Factory.define :run do |r|
  r.language "C/C++"
  r.source_code "#include <stdio.h>"
end

Factory.define :problem do |p|
  p.time_limit 1
  p.about "Some bogus text"
end