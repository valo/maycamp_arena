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

Given /^the user "([^\"]*)" submits a source for problem "([^\"]*)"$/ do |user, problem|
  Run.create!(:user_id => User.find_by_login(user).id, 
              :problem_id => Problem.find_by_name(problem).id,
              :source_code => '#include <stdio.h>',
              :language => "C/C++")
end

Given /^there is a finished contest with attributes:$/ do |contest_attrs|
  Contest.create!(contest_attrs.transpose.hashes.first.merge(:start_time => 2.days.ago, :end_time => 1.day.ago))
end

Given /^the user "([^\"]*)" submit a run for problem "([^\"]*)" with attributes:$/ do |user_login, problem_name, run_attrs|
  Run.create!(run_attrs.transpose.hashes.first.merge(
                :user_id => User.find_by_login(user_login).id, 
                :problem_id => Problem.find_by_name(problem_name).id)
              )
end
