Given /^there is a running contest named "([^\"]*)"$/ do |contest_name|
  Factory(:contest, :name => contest_name)
end

Given /^the contest "([^\"]*)" has a task named "([^\"]*)"$/ do |contest_name, task_name|
  contest = Contest.find_by_name(contest_name)
  Factory(:problem, :contest_id => contest.id, :name => task_name)
end

Given /^I am not logged in$/ do
  get logout_path
end

Given /^there is an? ([^\s]*) with attributes:$/ do |model, table|
  Factory(model.to_sym, table.transpose.hashes.first)
end

Given /^there is an invalid ([^\s]*) with attributes:$/ do |model, table|
  user = Factory.build(model.to_sym, table.transpose.hashes.first)
  user.save(false)
end

Given /^there is an admin user with attributes:$/ do |table|
  user = Factory.build(:user, table.transpose.hashes.first)
  user.admin = true
  user.save!
end

Given /^the user "([^\"]*)" submits a source for problem "([^\"]*)"$/ do |user, problem|
  Factory(:run, :user_id => User.find_by_login(user).id, 
                :problem_id => Problem.find_by_name(problem).id)
end

Given /^there is a finished contest with attributes:$/ do |contest_attrs|
  Factory(:contest, contest_attrs.transpose.hashes.first.merge(:start_time => 2.days.ago, :end_time => 1.day.ago))
end

Given /^the user "([^\"]*)" submit a run for problem "([^\"]*)" with attributes:$/ do |user_login, problem_name, run_attrs|
  Factory(:run, run_attrs.transpose.hashes.first.merge(
                :user_id => User.find_by_login(user_login).id, 
                :problem_id => Problem.find_by_name(problem_name).id))
end

Given /^the contest "([^\"]*)" is finished$/ do |contest_name|
  Time.stubs(:now => Contest.find_by_name!(contest_name).end_time + 1.second)
end

Given /^the problem "([^\"]*)" belongs to the category "([^\"]*)"$/ do |problem_name, category_name|
  Problem.find_by_name(problem_name).categories << Category.find_by_name(category_name)
end

Given /^the contest "([^\"]*)" has attributes:$/ do |contest_name, table|
  Contest.find_by_name(contest_name).update_attributes!(table.transpose.hashes.first)
end

Given /^the user "([^\"]*)" opens the contest "([^\"]*)"$/ do |user, contest|
  u = User.find_by_login(user) || User.find_by_name(user)
  c = Contest.find_by_name!(contest)
  
  c.contest_start_events.create!(:user => u)
end
