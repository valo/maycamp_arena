module CommonContestActions
  def self.included(base)
    # base.verify :only => :submit_solution, :method => :post, :redirect_to => '/'
  end
  
  def submit_solution
    @run = Run.new(params[:run].merge(:user => current_user).reject { |key, value| value.blank? })
    
    @contest = Contest.find_by_id(params[:contest_id])
    if @contest.auto_test?
      # If auto_test is true, we need to automatically put the run in WAITING (gradable) mode.
      @run.status = Run::WAITING
    elsif @contest.current?
      @run.status = Run::CHECKING
    end
    
    if @run.save
      redirect_to :action => "open_contest", :contest_id => params[:contest_id]
    else
      render :action => "open_contest"
    end
  end
  
  def view_source
    @run = current_user.runs_with_log.find(params[:run_id])
    render :action => "view_source"
  end
  
  def get_problem_description
    @problem = Problem.find(params[:problem_id])
    
    send_file File.join(@problem.tests_dir, "description.pdf"), :type => 'application/pdf', :disposition => 'inline'
  end
end