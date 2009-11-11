class PracticeController < ApplicationController
  include CommonContestActions
  
  before_filter :login_required
  before_filter :validate_contest
  
  def open_contest
    @run = Run.new
  end
  
  private
    def validate_contest
      @contest = Contest.find(params[:contest_id])
      redirect_to root_path if !@contest.practicable?
    end
end
