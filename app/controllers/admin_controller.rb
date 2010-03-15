class AdminController < Admin::BaseController
  layout 'main'
  
  def index
    redirect_to :controller => 'admin/contests', :action => "index"
  end
end
