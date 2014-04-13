require 'common_contest_actions'

class TimedContestController < ApplicationController
  include CommonContestActions

  before_filter :login_required
  before_filter :verify_contest

  def open_contest
    @run = Run.new
  end

  private
    def verify_contest
      @contest = Contest.find_by_id(params[:contest_id])
      if @contest.nil? or @contest.expired_for_user(current_user) or (!@contest.visible and !current_user.admin?)
        redirect_to root_path
        return
      end

      # Start the time of the contest
      @contest.contest_start_events.create(:user => current_user) unless @contest.user_open_time(current_user)
    end
end
