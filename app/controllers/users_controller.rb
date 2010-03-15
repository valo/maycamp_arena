class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :update]
  layout "main"
  
  def new
    @user = User.new
  end
  
  def show
    @user = current_user
  end
  
  def update
    @user = current_user
    
    @user.attributes = params[:user]
    if params[:user][:unencrypted_password]
      @user.unencrypted_password = params[:user][:unencrypted_password]
      @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    end
    
    if @user.save
      flash[:notice] = "Вашата информация беше обновена успешно!"
      redirect_to user_path(@user)
    else
      render :action => "show"
    end
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
