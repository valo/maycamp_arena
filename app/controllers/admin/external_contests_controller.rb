class Admin::ExternalContestsController < Admin::BaseController
  def index
    @contests = ExternalContest.paginate(:page => params[:page])
  end
  
  def new
    @contest = ExternalContest.new
  end
  
  def create
     @contest = ExternalContest.new(params[:external_contest])

     if @contest.save
       redirect_to :action => "index"
     else
       render :action => "new"
     end
  end
  
  def update
    @contest = ExternalContest.find(params[:id])
    @contest.attributes = params[:external_contest]
    
    if @contest.save
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @contest = ExternalContest.find(params[:id])
    @contest.destroy
    
    redirect_to :action => "index"
  end
  
  def edit
    @contest = ExternalContest.find(params[:id])
  end
  
  def show
    @contest = ExternalContest.find(params[:id])
  end
  
  def rematch
    @contest = ExternalContest.find(params[:id])
    
    @contest.match_results_to_users
    @contest.contest_results.each(&:save)
    
    redirect_to :action => "show"
  end
  
  def remove_links
    @contest = ExternalContest.find(params[:id], :include => :contest_results)
    
    @contest.contest_results.each do |res|
      res.user = nil
      res.save
    end
    
    redirect_to :action => "show"
  end
end
