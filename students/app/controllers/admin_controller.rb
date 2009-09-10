class AdminController < Admin::BaseController
  def index
    redirect_to :controller => 'admin/users', :action => "index"
  end
end
