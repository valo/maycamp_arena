class UsersController < ApplicationController
  before_filter :login_required_without_data_check, :only => [:update]
  layout "main"
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @daily_submits_report = Ezgraphix::Graphic.new(:w => 900, 
                                                   :div_name => "daily_submits_report",
                                                   :c_type => "line",
                                                   :precision => 0,
                                                   :caption => "Брой събмити на ден - Последни 3 седмици")
    @daily_submits_report.data = Run.count(:id, 
                                           :conditions => ["created_at > ? AND user_id = ?", 3.weeks.ago.to_s(:db), @user.id], 
                                           :select => "id",
                                           :group => "DATE_FORMAT(created_at, '%m/%d')")
  end
  
  def edit
    @user = current_user
    current_user.valid?
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
  
  def password_forgot
    if request.post?
      @user = User.find_by_email(params[:email])
      if @user
        @user.reset_token!
        UserMails.deliver_password_forgot(@user)
        flash.now[:notice] = "Успешно беше изпратен email със линк за рестартиране на паролата Ви!"
        params[:email] = ""
      else
        flash.now[:error] = "Няма потребител с този email"
      end
    end
  end
  
  def reset_password
    @user = User.find(params[:id], :conditions => { :token => params[:token]})
  end
  
  def do_reset_password
    @user = User.find(params[:id], :conditions => { :token => params[:token]})
    
    @user.unencrypted_password = params[:user][:unencrypted_password]
    @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    
    if @user.save
      flash[:notice] = "Паролата е рестартирана успешно"
      current_user = @user
      redirect_to(root_path)
    else
      render :action => "reset_password"
    end
  end
end
