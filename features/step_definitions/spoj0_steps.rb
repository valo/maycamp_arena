Given /^there is a running contest named "([^\"]*)"$/ do |contest_name|
  create(:contest, :name => contest_name, :start_time => 1.day.ago, :end_time => 1.day.from_now)
end

Given /^the contest "([^\"]*)" has a task named "([^\"]*)"$/ do |contest_name, task_name|
  contest = Contest.find_by_name(contest_name)
  create(:problem, :contest_id => contest.id, :name => task_name)
end

Given /^I am not logged in$/ do
  get logout_path
end

Given /^there is an? ([^\s]*) with attributes:$/ do |model, table|
  create(model.to_sym, table.transpose.hashes.first)
end

Given /^there is an invalid ([^\s]*) with attributes:$/ do |model, table|
  user = build(model.to_sym, table.transpose.hashes.first)
  user.save(validate: false)
end

Given /^there is an admin user with attributes:$/ do |table|
  user = build(:user, table.transpose.hashes.first)
  user.role = User::ADMIN
  user.save!
end

Given /^the user "([^\"]*)" submits a source for problem "([^\"]*)"$/ do |user, problem|
  create(:run, :user_id => User.find_by_login(user).id,
                :problem_id => Problem.find_by_name(problem).id)
end

Given /^there is a finished contest with attributes:$/ do |contest_attrs|
  create(:contest, contest_attrs.transpose.hashes.first.merge(:start_time => 2.days.ago, :end_time => 1.day.ago))
end

Given /^the user "([^\"]*)" submit a run for problem "([^\"]*)" with attributes:$/ do |user_login, problem_name, run_attrs|
  create(:run, run_attrs.transpose.hashes.first.merge(
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

Given(/^I am logged in as contestant user with attributes:$/) do |user_attrs|
  user = create(:user, user_attrs.transpose.hashes.first.merge(:unencrypted_password => "secret", :unencrypted_password_confirmation => "secret"))
  steps %{And I am on the login page
          And I fill in the following:
            | login                 | #{user.login}             |
            | password              | secret                    |
          And I press "Влез"}
end
