require 'uri'

class UsersController < ApplicationController
  before_filter :login_required_without_data_check, :only => [:update]
  layout "main"
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    rating_data = @user.rating_changes.map do |change|
      if change.contest
        [
          change.contest.name,
          {
            :value => change.rating,
            :color => change.rating_color,
            :name => change.contest.name,
            :hoverText => change.contest.name,
            :link => CGI.escape(
                       url_for(
                         :controller => :main,
                         :action => :results,
                         :contest_id => change.contest.id,
                         :contest_type => change.contest_result_type
                       )
                     )
          }
        ]
      else
        [
          @user.created_at.to_date,
          {
            :value => change.rating,
            :color => change.rating_color
          }
        ]
      end
    end
    
    @rating_report = Ezgraphix::Graphic.new(
                             :w => 900, 
                             :div_name => "rating_report",
                             :c_type => "line",
                             :precision => 0,
                             :rotate => "1",
                             :caption => "Рейтинг",
                             :color => "00FF00",
                             :names => "0",
                             :values => "0",
                             :y_lines => 5,
                             :f_number_scale => "0",
                             :rotate => "0",
                             :lines => [
                               {:startValue => 2000, :endValue => 2000, :color => "#FF0000"},
                               {:startValue => 1500, :endValue => 1500, :color => "#00FF00"},
                               {:startValue => 1000, :endValue => 1000, :color => "#0000FF"}
                             ],
                             :data => rating_data)
                             
    @daily_submits_report = Ezgraphix::Graphic.new(
                             :w => 900, 
                             :div_name => "daily_submits_report",
                             :c_type => "line",
                             :precision => 0,
                             :rotate => "1",
                             :caption => "Брой събмити на ден - Последни 3 седмици",
                             :color => "00FF00",
                             :data => Run.count(:id, 
                                                :conditions => ["created_at > ? AND user_id = ?", 3.weeks.ago.to_s(:db), @user.id], 
                                                :select => "id",
                                                :group => "DATE_FORMAT(created_at, '%m/%d')"))
    @total_submits_report = Ezgraphix::Graphic.new(
                             :w => 900, 
                             :div_name => "total_submits_report",
                             :c_type => "area2d",
                             :rotate => "1",
                             :precision => 0,
                             :caption => "Брой събмити на ден",
                             :data => Run.count(:id, 
                                                :conditions => ["user_id = ?", @user.id], 
                                                :select => "id",
                                                :group => "DATE_FORMAT(created_at, '%Y/%m/%d')"))

    @runs = Run.all(:include => [ {:problem => :contest}, :user ],
                    :limit => 10,
                    :select => (Run.column_names - ["log", "source_code"]).join(","),
                    :conditions => ["contests.practicable AND contests.visible AND NOT users.admin AND runs.user_id = ?", @user.id])
  end
  
  def edit
    @user = current_user
    current_user.valid?
  end
  
  def update
    @user = current_user
    
    @user.attributes = params[:user]
    if !params[:user][:unencrypted_password].blank?
      @user.unencrypted_password = params[:user][:unencrypted_password]
      @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]
    end
    
    if @user.save
      flash[:notice] = "Вашата информация беше обновена успешно!"
      redirect_to user_path(@user)
    else
      redirect_to :action => "show"
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
    
    if @user.unencrypted_password == @user.unencrypted_password_confirmation
      @user.save(false)
      flash[:notice] = "Паролата е рестартирана успешно"
      current_user = @user
      redirect_to(root_path)
    else
      @user.errors.add(:password, "не съвпада с потвърждението")
      render :action => "reset_password"
    end
  end
end
