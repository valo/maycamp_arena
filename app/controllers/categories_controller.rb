class CategoriesController < ApplicationController
  layout "main"
  before_filter :check_user_profile
  
  def index
    @categories = Category.find(:all).sort {|x, y| x.name.casecmp(y.name) }
  end

  def show
    @category = Category.find(params[:id])
  end
end