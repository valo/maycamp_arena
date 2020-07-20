class Admin::BaseController < ApplicationController
  before_action :login_required
  helper :admin
  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected
    def set_locale
      I18n.locale = :en
    end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(new_session_path)
  end
end
