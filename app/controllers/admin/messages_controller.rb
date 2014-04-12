# encoding: utf-8

class Admin::MessagesController < ApplicationController
  def new
    @message = Message.new
  end
  
  def create
    @message = Message.new(params[:message])
    
    if @message.save
      @message.deliver
      flash[:notice] = "Съобщението беше пратено успешно"
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end
  
  def show
    @message = Message.find(params[:id])
  end
end
