require 'ostruct'

class Admin::EmailsController < ApplicationController
  def index
    @email = OpenStruct.new(:subject => "", :body => "")
  end
end
