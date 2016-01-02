require 'ostruct'

class Admin::UsersController < Admin::BaseController
  def index
    authorize :user, :index?

    @search = OpenStruct.new(params[:search])
    @users = User.all
    if !@search.q.blank?
      @users = @users.where("login LIKE ? OR name LIKE ? OR email LIKE ?", "%#{@search.q}%", "%#{@search.q}%", "%#{@search.q}%")
    end
    @users = @users.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    authorize :user, :new?

    @user = User.new
  end

  def create
    authorize :user, :create?

    @user = User.new(params.require(:user).permit!)
    @user.unencrypted_password = params[:user][:unencrypted_password]
    @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    @user.encrypted_password = User.devise_encrypt_password(params[:user][:unencrypted_password])

    if @user.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    authorize user
  end

  def update
    authorize user

    user.attributes = params.require(:user).permit!.except(:unencrypted_password, :unencrypted_password_confirmation)

    user.role = params[:user][:role] unless params[:user][:role].blank?
    unless params[:user][:unencrypted_password].blank?
      user.unencrypted_password = params[:user][:unencrypted_password]
      user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
      user.encrypted_password = User.devise_encrypt_password(params[:user][:unencrypted_password])
    end

    if user.save
      flash[:notice] = "The user was changed successfully"
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def show
    authorize user

    @runs = user.runs.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  def restart_time
    authorize user

    @event = ContestStartEvent.find_by_user_id_and_contest_id(params[:id], params[:contest_id])
    @event.andand.destroy

    ContestStartEvent.create(:user_id => params[:id], :contest_id => params[:contest_id])

    redirect_to admin_user_path(params[:id])
  end

  def destroy
    authorize user

    user.destroy
    redirect_to admin_users_path
  end

  def impersonate
    authorize user

    self.current_user = user

    redirect_to root_path
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
end
