class Admin::UsersController < Admin::BaseController
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
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    
    @user.attributes = params[:user]
    
    @user.admin = params[:user][:admin]
    unless params[:user][:password].blank?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end
    
    if @user.save
      flash[:notice] = "The user was changed successfully"
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
end
