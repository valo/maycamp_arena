class Admin::ContestsController < ApplicationController
  layout 'admin'
  def index
    @contests = Contest.all
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
      flash[:notice] = "Contest updated successfully"
      redirect_to edit_admin_contest_path(@contest.id)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @contest = Contest.find(params[:id])
    
    @contest.destroy
    
    redirect_to :action => "index"
  end
end