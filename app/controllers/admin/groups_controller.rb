class Admin::GroupsController < Admin::BaseController

  after_action :verify_authorized

  def index
    authorize :groups

    @groups = Group.all
  end

  def show
    authorize group
  end

  def new
    authorize :groups, :new?

    @group = Group.new
  end

  def create
    authorize :groups, :create?

    @group = Group.new(params.require(:group).permit!)

    if @group.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    authorize group
  end

  def update
    authorize :groups, :update?

    group.attributes = params.require(:group).permit!

    if group.save
      redirect_to admin_groups_path
    else
      render :action => "edit"
    end
  end

  def destroy
    authorize group

    if Contest.exists?(group_id: ["#{group.id}"])
      redirect_to admin_groups_path, :notice => "Unable to delete Group, which isn't empty."
    else
      group.destroy
      redirect_to :action => "index"
    end

  end

  private

  def group
    @group ||= Group.find(params[:id])
  end

end