class Admin::BaseController < ApplicationController
  before_filter :login_required
  helper :admin
  
  protected
    def set_locale
      I18n.locale = :en
    end
end
