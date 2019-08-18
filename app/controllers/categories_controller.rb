class CategoriesController < ApplicationController
  layout "main"
  before_action :check_user_profile

  def index
    @categories = Category.all.sort {|x, y| x.name.casecmp(y.name) }
  end

  def show
    @category = Category.find(params[:id])
  end
end