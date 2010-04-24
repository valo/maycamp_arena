class TaskCategoriesController < ApplicationController
  # GET /task_categories
  # GET /task_categories.xml
  def index
    @task_categories = TaskCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @task_categories }
    end
  end

  # GET /task_categories/1
  # GET /task_categories/1.xml
  def show
    @task_category = TaskCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task_category }
    end
  end

  # GET /task_categories/new
  # GET /task_categories/new.xml
  def new
    @task_category = TaskCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task_category }
    end
  end

  # GET /task_categories/1/edit
  def edit
    @task_category = TaskCategory.find(params[:id])
  end

  # POST /task_categories
  # POST /task_categories.xml
  def create
    @task_category = TaskCategory.new(params[:task_category])

    respond_to do |format|
      if @task_category.save
        flash[:notice] = 'TaskCategory was successfully created.'
        format.html { redirect_to(@task_category) }
        format.xml  { render :xml => @task_category, :status => :created, :location => @task_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /task_categories/1
  # PUT /task_categories/1.xml
  def update
    @task_category = TaskCategory.find(params[:id])

    respond_to do |format|
      if @task_category.update_attributes(params[:task_category])
        flash[:notice] = 'TaskCategory was successfully updated.'
        format.html { redirect_to(@task_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /task_categories/1
  # DELETE /task_categories/1.xml
  def destroy
    @task_category = TaskCategory.find(params[:id])
    @task_category.destroy

    respond_to do |format|
      format.html { redirect_to(task_categories_url) }
      format.xml  { head :ok }
    end
  end
end
