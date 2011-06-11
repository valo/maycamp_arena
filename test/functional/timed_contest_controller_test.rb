require File.dirname(__FILE__) + '/../test_helper'

class TimedContestControllerTest < ActionController::TestCase     
  test "ramaining time for a contest" do
    contest = Factory(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 1.day.from_now)
    user = Factory(:user)
    
    ContestStartEvent.create!(:user => user, :contest => contest)
    
    @request.session[:user_id] = user.id
    
    get :open_contest, :contest_id => contest.id
    
    assert_response :success
    assert_template "open_contest"
    assert_match "4 часа 59 минути", @response.body
  end

  test "ramaining time for a contest near the end of the contest" do
    contest = Factory(:contest, :duration => 300, :start_time => 1.minute.ago, :end_time => 3.hours.from_now)
    user = Factory(:user)
    
    ContestStartEvent.create!(:user => user, :contest => contest)
    
    @request.session[:user_id] = user.id
    
    get :open_contest, :contest_id => contest.id
    
    assert_response :success
    assert_template "open_contest"
    assert_match "2 часа 59 минути", @response.body
  end
end