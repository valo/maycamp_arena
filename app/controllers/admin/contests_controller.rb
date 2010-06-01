class Admin::ContestsController < Admin::BaseController
  def index
    @contests = Contest.paginate(:page => params[:page], :per_page => 20, :order => "end_time DESC")
  end
  
  def show
    redirect_to admin_contest_problems_path(params[:id])
  end
  
  def new
    @contest = Contest.new
  end
  
  def create
    @contest = Contest.new params[:contest]
    
    if @contest.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def edit
    @contest = Contest.find(params[:id])
  end
  
  def update
    @contest = Contest.find(params[:id])
    @contest.attributes = params[:contest]
    
    if @contest.save
      flash[:notice] = "Състезанието е обновено успешно."
      redirect_to edit_admin_contest_path(@contest.id)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @contest = Contest.destroy(params[:id])
    
    redirect_to :action => "index"
  end
end
