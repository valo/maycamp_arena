require File.dirname(__FILE__) + '/../test_helper'

class ContestTest < ActiveSupport::TestCase
  test "using the last run in the results" do
    contest = Factory(:contest, :start_time => 1.day.ago, :end_time => 1.day.from_now)
    problem = Factory(:problem, :contest => contest)
    user = Factory(:user)
    
    user.contest_start_events.create!(:contest => contest)
    
    run1 = Factory(:run, :problem => problem, :user => user, :status => "ok ok ok ok", :created_at => 2.minutes.ago)
    run2 = Factory(:run, :problem => problem, :user => user, :status => "ok wa wa wa", :created_at => 1.minute.ago)
    
    res = contest.generate_contest_results
    
    assert_equal res[0].last, 25
  end

  test "using the best run in the results" do
    contest = Factory(:contest, :start_time => 1.day.ago, :end_time => 1.day.from_now, :best_submit_results => true)
    problem = Factory(:problem, :contest => contest)
    user = Factory(:user)
    
    user.contest_start_events.create!(:contest => contest)
    
    run1 = Factory(:run, :problem => problem, :user => user, :status => "ok ok ok ok", :created_at => 2.minutes.ago)
    run2 = Factory(:run, :problem => problem, :user => user, :status => "ok wa wa wa", :created_at => 1.minute.ago)
    
    res = contest.generate_contest_results
    
    assert_equal res[0].last, 100
  end
end