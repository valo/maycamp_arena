class Admin::StatusesController < Admin::BaseController
  def show
    @last_runs = Run.paginate(:per_page => 50,
                              :page => params[:page],
                              :select => (Run.column_names - ["log", "source_code"]).join(','),
                              :include => { :problem => :contest, :user => nil })
  end
end