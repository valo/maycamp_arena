class Admin::CategoriesController < Admin::BaseController
  def index
    authorize :categories, :index?

    @categories = Category.all
  end

  def show
    authorize category
  end

  def new
    authorize :categories, :new?

    @category = Category.new
  end

  def create
    authorize :categories, :create?

    @category = Category.new(params.require(:category).permit!)

    if @category.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    authorize category
  end

  def update
    authorize category

    category.attributes = params.require(:category).permit!

    if category.save
      redirect_to admin_categories_path
    else
      render :action => "edit"
    end
  end

  def destroy
    authorize category

    category.destroy
    redirect_to admin_categories_path
  end

  private

  def category
    @category ||= Category.find(params[:id])
  end

end
