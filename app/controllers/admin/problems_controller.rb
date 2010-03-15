require 'zip/zip'

class Admin::ProblemsController < Admin::BaseController
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
  
  def destroy
    @contest = Contest.find params[:contest_id]
    Problem.destroy(params[:id])
    redirect_to admin_contest_problems_path(@contest)
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
  
  def purge_files
    @problem = Problem.find(params[:id])
    Dir[File.join(@problem.tests_dir, "*")].each do |filename|
      next unless File.file?(filename)
      logger.warn "Deleting file #{filename}"
      File.delete filename
    end
    
    Configuration.set!(Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "Files successfully purged"
    
    redirect_to admin_contest_problem_path(@problem.contest, @problem)
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
          if filename.file? and !filename.name.include?('/')
            dest = File.join(@problem.tests_dir, filename.name).downcase
            FileUtils.rm(dest) if File.exists?(dest)
            filename.extract dest
          end
        end
      else
        dest = File.join(@problem.tests_dir, @upload.original_filename)
        FileUtils.cp @upload.local_path, dest
        # Set the permissions of the copied file to the right ones. This is
        # because the uploads are created with 0600 permissions in the /tmp
        # folder. The 0666 & ~File.umask will set the permissions to the default
        # ones of the current user. See the umask man page for details
        FileUtils.chmod 0666 & ~File.umask, dest
      end
    end
    Configuration.set!(Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "File successfully upoaded"
    
    redirect_to admin_contest_problem_path(@problem.contest, @problem)
  ensure
    FileUtils.rm params[:tests][:file].local_path
  end
  
  def download_file
    @problem = Problem.find(params[:id])
    
    send_file File.join(@problem.tests_dir, params[:file])
  end
end
