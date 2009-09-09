class Admin::UsersController < ApplicationController
  layout 'admin'
  
  def index
    @users = User.all
  end
end
