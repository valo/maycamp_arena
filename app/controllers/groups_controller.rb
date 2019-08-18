class GroupsController < ApplicationController
  layout "main"
  before_action :login_required

  def show
    @group = Group.find(params[:id])
  end
end
