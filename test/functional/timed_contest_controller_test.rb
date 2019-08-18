# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'

class TimedContestControllerTest < ActionController::TestCase
  test "ramaining time for a contest" do
    contest = create(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 1.day.from_now)
    user = create(:user)

    ContestStartEvent.create!(:user => user, :contest => contest)

    @request.session[:user_id] = user.id

    get :open_contest, params: { contest_id:  contest.id }

    assert_response :success
    assert_template "open_contest"
    assert_match "Оставащо време", @response.body
  end

  test "ramaining time for a contest near the end of the contest" do
    contest = create(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 3.hours.from_now)
    user = create(:user)

    ContestStartEvent.create!(:user => user, :contest => contest)

    @request.session[:user_id] = user.id

    get :open_contest, params: { contest_id: contest.id }

    assert_response :success
    assert_template "open_contest"
    assert_match "Оставащо време", @response.body
  end

  test "trying to submit solution during the end of the contest" do
    contest = create(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 1.day.from_now)
    problem = create(:problem, :name => "test problem", :contest => contest)
    user = create(:user)

    ContestStartEvent.create!(:user => user, :contest => contest)

    @request.session[:user_id] = user.id

    assert_difference "Run.count", 1 do
      post :submit_solution,
           params: {
            contest_id: contest.id,
            run: {
              problem_id: problem.id,
              language: Run.languages.first,
              source_code: "test"
            }
           }
      assert_redirected_to :action => :open_contest, :contest_id => contest.id
    end
  end

  test "trying to submit solution after the end of the contest" do
    contest = create(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 1.day.from_now)
    problem = create(:problem, :name => "test problem", :contest => contest)
    user = create(:user)

    ContestStartEvent.create!(:user => user, :contest => contest)

    Time.stubs(:now => 310.minutes.from_now)

    @request.session[:user_id] = user.id

    assert_difference "Run.count", 0 do
      post :submit_solution,
           params: {
            contest_id: contest.id,
            run: {
              problem_id: problem.id,
              language: Run.languages.first,
              source_code: "test"
            }
           }
      assert_redirected_to root_path
    end
  end

  test "trying to submit solution after the end of the contest but when opened near the end of it" do
    contest = create(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 200.minutes.from_now)
    problem = create(:problem, :name => "test problem", :contest => contest)
    user = create(:user)

    ContestStartEvent.create!(:user => user, :contest => contest)

    Time.stubs(:now => 210.minutes.from_now)

    @request.session[:user_id] = user.id

    assert_difference "Run.count", 0 do
      post :submit_solution,
           params: {
            contest_id: contest.id,
            run: {
              problem_id: problem.id,
              language: Run.languages.first,
              source_code: "test"
            }
          }

      assert_redirected_to root_path
    end
  end
end
