class Admin::UsersController < ApplicationController
  layout 'admin'
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    
    if @user.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
end
