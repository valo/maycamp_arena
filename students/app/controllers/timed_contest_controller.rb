class TimedContestController < ApplicationController
  before_filter :login_required
  before_filter :verify_contest
  
  layout "main"
  
  def open_contest
    @run = Run.new
  end
  
  def submit_solution
    @run = Run.new(params[:run].merge(:user => current_user))
    
    if @run.save
      redirect_to :action => "open_contest", :contest_id => params[:contest_id]
    else
      render :action => "open_contest"
    end
  end
  
  def view_source
    @run = current_user.runs.find(params[:run_id])
  end
  
  def get_problem_description
    @problem = Problem.find(params[:problem_id])
    
    send_file File.join(@problem.tests_dir, "description.pdf"), :type => 'application/pdf', :disposition => 'inline'
  end
  
  private
    def verify_contest
      @contest = Contest.find_by_id(params[:contest_id])
      if @contest.nil? or @contest.expired_for_user(current_user)
        redirect_to root_path
        return
      end
      
      # Start the time of the contest
      @contest.contest_start_events.create(:user => current_user) unless @contest.user_open_time(current_user)
    end
end
