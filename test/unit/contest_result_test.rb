require 'test_helper'

class ContestResultTest < ActiveSupport::TestCase
  def setup
    [User, Contest].each(&:destroy_all)
  end
  
  test "results contain only contesters" do
    user_admin = Factory(:user, :admin => true)
    assert (not user_admin.participates_in_contests?)
    user_contester = Factory(:user, :contester => true, :admin => false)
    assert user_contester.participates_in_contests?
    
    contest = Factory(:contest)
    contest.problems << Factory(:problem, :name => "Problem", :contest => contest) while contest.problems.length < 3
    assert contest.problems.length > 0
    
    # Add first contester's runs
    contest_start_event1 = Factory(:contest_start_event, :contest => contest, :user => user_admin)    
    run1 = Factory(:run, :user => user_admin, :problem => contest.problems[0])
    assert user_admin.runs.length == 1
    assert contest.problems[0].runs.length == 1

    # Add second contester's runs
    contest_start_event2 = Factory(:contest_start_event, :contest => contest, :user => user_contester)
    run2 = Factory(:run, :user => user_contester, :problem => contest.problems[0])
    assert user_contester.runs.length == 1    
    assert contest.problems[0].runs.length == 1
    
    contest_results = contest.generate_contest_results
    assert contest_results.length == 1
  end
end
