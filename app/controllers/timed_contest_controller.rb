require 'common_contest_actions'

class TimedContestController < ApplicationController
  include CommonContestActions

  before_filter :login_required
  before_filter :verify_contest
  before_filter :track_contest_open_time

  def open_contest
    @run = Run.new
  end

  private

  def verify_contest
    redirect_to root_path if contest.expired_for_user(current_user) || !contest.visible
  end

  def track_contest_open_time
    contest.contest_start_events.create(user: current_user) unless contest.user_open_time(current_user)
  end

  def contest
    @contest ||= Contest.find(params[:contest_id])
  end
end
