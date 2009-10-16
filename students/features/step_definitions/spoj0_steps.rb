Given /^there is a running contest named "([^\"]*)"$/ do |contest_name|
  Contest.create!(:name => contest_name, 
                 :start_time => 1.minute.ago,
                 :duration => 60,
                 :end_time => 1.hour.from_now,
                 :about => contest_name)
end

Given /^the contest "([^\"]*)" has a task named "([^\"]*)"$/ do |contest_name, task_name|
  contest = Contest.find_by_name(contest_name)
  contest.problems.create!(:name => task_name, :time_limit => 1, :about => task_name)
end

Given /^I am not logged in$/ do
  get logout_path
end

Given /^there is a user with attributes:$/ do |table|
  User.create! table.transpose.hashes.first
end

Given /^there is an admin user with attributes:$/ do |table|
  user = User.new(table.transpose.hashes.first)
  user.admin = true
  user.save!
end


def login_user(user)
  post session_path, :login => user.login, :password => user.password
end
