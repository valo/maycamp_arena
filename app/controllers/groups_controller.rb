class GroupsController < ApplicationController
  layout "main"
  before_filter :check_user_profile

  def index
    @groups = Group.all.sort {|x, y| x.name.casecmp(y.name) }
  end

  def show
    @group = Group.find(params[:id])
  end
end
