class Admin::StatusesController < Admin::BaseController
  def show
    authorize :admin_status, :show?

    @last_runs = Run.includes({ :problem => :contest }, :user).
                     order("runs.created_at DESC").
                     paginate(:per_page => 50,
                              :page => params[:page])
  end
end
