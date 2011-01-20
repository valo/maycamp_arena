require 'ostruct'

class Admin::UsersController < Admin::BaseController
  def index
    @search = OpenStruct.new(params[:search])
    @users = User.scoped
    if !@search.q.blank?
      @users = @users.scoped(:conditions => ["login LIKE ? OR name LIKE ? OR email LIKE ?", "%#{@search.q}%", "%#{@search.q}%", "%#{@search.q}%"])
    end
    @users = @users.paginate(:page => params[:page], :per_page => 20)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.unencrypted_password = params[:user][:unencrypted_password]
    @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    
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
    
    @user.attributes = params[:user].except(:unencrypted_password, :unencrypted_password_confirmation)
    
    @user.admin = params[:user][:admin]
    @user.contester = params[:user][:contester]
    unless params[:user][:unencrypted_password].blank?
      @user.unencrypted_password = params[:user][:unencrypted_password]
      @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
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
    @runs = @user.runs.paginate(:page => params[:page], :per_page => 10)
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
