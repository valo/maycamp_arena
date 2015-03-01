require 'test_helper'

class ContestResultTest < ActiveSupport::TestCase
  test "results contain only contesters" do
    user_admin = create(:user, :role => User::ADMIN)
    assert_equal false, user_admin.participates_in_contests?
    user_contester = create(:user, :role => User::CONTESTER)
    assert user_contester.participates_in_contests?

    contest = create(:contest)
    contest.problems << create(:problem, :name => "Problem", :contest => contest) while contest.problems.length < 3
    assert_equal 3, contest.problems.length

    # Add first contester's runs
    contest_start_event1 = create(:contest_start_event, :contest => contest, :user => user_admin)
    run1 = create(:run, :user => user_admin, :problem => contest.problems.first)
    assert_equal 1, user_admin.runs.length
    assert_equal 1, contest.problems[0].runs.length

    # Add second contester's runs
    contest_start_event2 = create(:contest_start_event, :contest => contest, :user => user_contester)
    run2 = create(:run, :user => user_contester, :problem => contest.problems.first)
    assert_equal 1, user_contester.runs.length
    assert_equal 1, contest.problems.first.runs.length

    contest_results = contest.generate_contest_results
    assert_equal 1, contest_results.length
  end
end
