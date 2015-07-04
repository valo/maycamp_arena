# encoding: utf-8

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
      if change.contest_result
        {
          :x => change.contest_result.contest.user_open_time(@user),
          :y => change.rating.to_f,
          :name => change.contest_result.contest.name,
          :color => change.rating_color,
          :url => url_for(:controller => :main, :action => :results, :contest_id => change.contest_result.contest.id, :contest_type => change.contest_result.class)
        }
      else
        nil
      end
    end.compact

    gon.rating_report = rating_data.to_a

    gon.daily_submits_report = Run.where("created_at > ? AND user_id = ?", 3.weeks.ago.to_s(:db), @user.id).
                                select("id").
                                group("DATE_FORMAT(created_at, '%Y/%m/%d')").
                                count(:id).to_a.sort
    gon.total_submits_report = Run.where(["user_id = ?", @user.id]).
                                select("id").
                                group("DATE_FORMAT(created_at, '%Y/%m/%d')").
                                count(:id).to_a.sort

    @runs = Run.includes({:problem => :contest}, :user).
                where(:contests => {:practicable => true, :visible => true }, :runs => { :user_id => @user.id }).
                order("runs.created_at DESC").
                paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @user = current_user
    current_user.valid?
  end

  def update
    @user = current_user

    @user.attributes = params.require(:user).permit(:login, :name, :city, :email)
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
    @user = User.new(params.require(:user).permit(:login, :name, :email, :city))
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
        UserMails.password_forgot(@user).deliver
        flash.now[:notice] = "Успешно беше изпратен email със линк за рестартиране на паролата Ви!"
        params[:email] = ""
      else
        flash.now[:error] = "Няма потребител с този email"
      end
    end
  end

  def reset_password
    @user = User.where(:token => params[:token]).find(params[:id])
  end

  def do_reset_password
    @user = User.where(:token => params[:token]).find(params[:id])

    @user.unencrypted_password = params[:user][:unencrypted_password]
    @user.unencrypted_password_confirmation = params[:user][:unencrypted_password_confirmation]

    if @user.unencrypted_password == @user.unencrypted_password_confirmation
      @user.save(validate: false)
      flash[:notice] = "Паролата е рестартирана успешно"
      current_user = @user
      redirect_to(root_path)
    else
      @user.errors.add(:password, "не съвпада с потвърждението")
      render :action => "reset_password"
    end
  end
end
