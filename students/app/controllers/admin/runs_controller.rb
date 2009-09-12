class Admin::RunsController < ApplicationController
  layout 'admin'
  
  def index
    @runs = Run.scoped(:include => :problem)
    @runs = @runs.scoped(:conditions => { :problem_id => params[:problem_id] }) unless params[:problem_id].blank?
    @runs = @runs.scoped(:conditions => ['problems.contest_id = ?', params[:contest_id]]) unless params[:contest_id].blank?
    
    @contest = Problem.find(params[:contest_id]) unless params[:contest_id].blank?
    @problem = Problem.find(params[:problem_id]) unless params[:problem_id].blank?
  end
  
  def queue
    @runs = Run.scoped(:include => :problem)
    @runs = @runs.scoped(:conditions => { :problem_id => params[:problem_id] }) unless params[:problem_id].blank?
    @runs = @runs.scoped(:conditions => ["problems.contest_id = ?", params[:contest_id]]) unless params[:contest_id].blank?
    @runs.each { |run| run.update_attributes(:status => Run::WAITING) }
    redirect_to :back
  end
end
