require 'zip/zip'

class Admin::ProblemsController < ApplicationController
  layout "admin"
  
  def new
    @contest = Contest.find params[:contest_id]
    @problem = Problem.new
  end
  
  def index
    @contest = Contest.find params[:contest_id]
  end
  
  def create
    @contest = Contest.find params[:contest_id]
    @problem = @contest.problems.build params[:problem]
    
    if @problem.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def show
    @problem = Problem.find params[:id]
  end
  
  def edit
    @problem = Problem.find params[:id]
  end
  
  def update
    @problem = Problem.find params[:id]
    @problem.attributes = params[:problem]
    
    if @problem.save
      redirect_to admin_contest_problems_path(@problem.contest)
    else
      render :action => "edit"
    end
  end
  
  def upload_tests
    @problem = Problem.find(params[:id])
  end
  
  def do_upload_tests
    @problem = Problem.find(params[:id])
    Dir[File.join(@problem.tests_dir, "*.{in,ans}*")].each do |filename|
      logger.warn "Deleting file #{filename}"
      File.delete filename
    end
    
    do_upload_file
  end
  
  def upload_file
    @problem = Problem.find(params[:id])
  end
  
  def do_upload_file
    @problem = Problem.find(params[:id])
    # Create the folders if they doesn't exist
    FileUtils.mkdir_p(@problem.tests_dir)

    @upload = params[:tests][:file]
    case @upload
    when ActionController::UploadedStringIO
      local_file = File.join(@problem.tests_dir, @upload.original_filename)
      File.open(local_file) { |f| f.write(@upload.read) }
    when Tempfile
      if @upload.original_filename.ends_with("zip")
        # Extract the bundle
        Zip::ZipFile.foreach(@upload.local_path) do |filename|
          if filename.file?
            dest = File.join(@problem.tests_dir, filename.name)
            FileUtils.rm(dest) if File.exists?(dest)
            filename.extract dest
          end
        end
      else
        FileUtils.cp @upload.local_path, File.join(@problem.tests_dir, @upload.original_filename)
      end
    end
    
    redirect_to admin_contest_problem_path(@problem.contest, @problem)
  ensure
    FileUtils.rm params[:tests][:file].local_path
  end
  
  def download_file
    @problem = Problem.find(params[:id])
    
    send_file File.join(@problem.tests_dir, params[:file])
  end
end
