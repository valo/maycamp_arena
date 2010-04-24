class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.find(:all)
  end

  def show
    @category = Category.find params[:id]
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new params[:category]

    if @category.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    @category.attributes = params[:category]

    if @category.save
      redirect_to admin_categories_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @category = Category.find params[:id]
    @category.destroy
    redirect_to admin_categories_path
  end

end
