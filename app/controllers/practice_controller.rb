require 'common_contest_actions'

class PracticeController < ApplicationController
  include CommonContestActions

  before_action :login_required
  before_action :validate_contest

  def open_contest
    @run = Run.new
  end

  private

  def validate_contest
    redirect_to root_path unless contest.practicable?
  end

  def contest
    @contest ||= Contest.find(params[:contest_id])
  end
end
