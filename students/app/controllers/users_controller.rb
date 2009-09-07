class UsersController < ApplicationController
  before_filter :verify_logged_in, :except => [:new, :create, :logoff, :login]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      session[:logged_user_id] = @user.id
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def index
    
  end
  
  def logoff
    session[:logged_user_id] = nil
    redirect_to :action => "login"
  end
  
  def login
    
  end
end
