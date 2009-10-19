class Admin::UsersController < Admin::BaseController
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
  
  def show
    @user = User.find(params[:id])
  end
  
  def restart_time
    @event = ContestStartEvent.find_by_user_id_and_contest_id(params[:id], params[:contest_id])
    @event.andand.destroy
    
    ContestStartEvent.create(:user_id => params[:id], :contest_id => params[:contest_id])
    
    redirect_to admin_user_path(params[:id])
  end
  
  def destroy
    User.destroy(params[:id])
    redirect_to :action => "index"
  end
end
