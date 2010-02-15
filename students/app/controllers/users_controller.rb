class UsersController < ApplicationController
  layout "main"
  
  def new
    @user = User.new
  end
 
  def create
    reset_session
    @user = User.new(params[:user])
    @user.unencrypted_password = params[:user][:unencrypted_password]
    @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    
    if @user.save
      self.current_user = @user # !! now logged in
      redirect_to root_path
      flash[:notice] = "Благодаря за регистрацията."
    else
      flash[:error]  = "Регистрацията не може да бъде завършена. Моля вижте описанието на проблемите по-долу."
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
end
