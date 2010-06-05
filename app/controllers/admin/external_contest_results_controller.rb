class Admin::ExternalContestResultsController < Admin::BaseController
  def update
    @contest = ExternalContest.find(params[:external_contest_id])
    @result = @contest.contest_results.find(params[:id])
    
    @result.attributes = params[:external_contest_result]
    
    @result.save
    
    redirect_to admin_external_contest_path(@contest)
  end
  
  def remove_user
    @contest = ExternalContest.find(params[:external_contest_id])
    @result = @contest.contest_results.find(params[:id])
    
    @result.user = nil
    @result.save
    
    redirect_to admin_external_contest_path(@contest)
  end
end