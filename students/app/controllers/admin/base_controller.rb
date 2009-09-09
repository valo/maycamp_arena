class Admin::BaseController < ApplicationController
  before_filter :login_required
  
  protected
    def authorized?(action = action_name, resource = nil)
      super && current_user.admin?
    end
end
