class MainController < ApplicationController
  def index
  end
  
  def open_contest
    @contest = Contest.find(params[:contest_id])
    if !@contest.allow_user_submit(current_user)
      redirect_to :action => "index"
      return
    end
    
    @contest.contest_start_events.create(:user => current_user) unless @contest.user_open_time(current_user)
    
    @run = Run.new
  end
  
  def submit_solution
    @contest = Contest.find(params[:contest_id])
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
    if !@problem.contest.allow_user_submit(current_user)
      redirect_to :action => "index"
    end
    
    send_file File.join(@problem.tests_dir, "description.pdf"), :type => 'application/pdf', :disposition => 'inline'
  end
end