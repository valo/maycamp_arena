require 'zip/zip'

class Admin::ProblemsController < Admin::BaseController
  def new
    authorize contest, :edit?
    @problem = Problem.new
  end

  def index
    authorize contest, :edit?
  end

  def create
    authorize contest, :edit?

    params[:problem][:category_ids] ||= []
    @problem = contest.problems.build(params.require(:problem).permit!.except(:archive, :solution))

    if @problem.save

      if !params[:problem][:archive].blank?
        process_uploaded_file(params[:problem][:archive])
        ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
      end

      if !params[:problem][:solution].blank?
        Run.create!(:problem => @problem,
                    :user => current_user,
                    :language => Run.languages.first,
                    :source_code => params[:problem][:solution].tempfile.read)
        redirect_to admin_contest_problem_runs_path(@contest, @problem)
      else
        redirect_to :action => "index"
      end
    else
      render :action => "new"
    end
  end

  def destroy
    authorize contest, :edit?

    Problem.destroy(params[:id])
    redirect_to admin_contest_problems_path(contest)
  end

  def show
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?
  end

  def edit
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?
  end

  def update
    params[:problem][:category_ids] ||= []
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?

    @problem.attributes = params.require(:problem).permit!

    if @problem.save
      redirect_to admin_contest_problems_path(@problem.contest)
    else
      render :action => "edit"
    end
  end

  def purge_files
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?

    Dir[File.join(@problem.tests_dir, "*")].each do |filename|
      next unless File.file?(filename)
      logger.warn "Deleting file #{filename}"
      File.delete filename
    end

    ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "Files successfully purged"

    redirect_to admin_contest_problem_path(@problem.contest, @problem)
  end

  def upload_file
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?
  end

  def do_upload_file
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?

    process_uploaded_file params[:tests][:file]

    ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "File successfully upoaded"

    redirect_to admin_contest_problem_path(@problem.contest, @problem)
  ensure
    params[:tests][:file].tempfile.unlink
  end

  def download_file
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?

    send_file File.join(@problem.tests_dir, params[:file])
  end

  def compile_checker
    @problem = Problem.find(params[:id])

    authorize @problem.contest, :edit?

    checker_source = @problem.checker_source
    if checker_source.nil?
      flash[:error] = "No checker source found"
      redirect_to :action => "show", :id => params[:id]
    else
      checker_output = checker_source.gsub(/\.c(pp)?$/, "")
      @compile_result = StringIO.new
      case checker_source
        when /.*cpp$/
          @compile_result.puts "g++ #{checker_source} -o #{checker_output} 2>&1"
          @compile_result.puts `g++ #{checker_source} -o #{checker_output} 2>&1`
        when /.*c$/
          @compile_result.puts "gcc #{checker_source} -o #{checker_output} 2>&1"
          @compile_result.puts `gcc #{checker_source} -o #{checker_output} 2>&1`
        else
          flash[:error] = "Don't know how to compile #{checker_source}"
      end

      if $? == 0
        @compile_result.puts "<b>SUCCESS</b>"
      else
        @compile_result.puts "<b>FAILURE</b>"
      end
      ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
      flash[:notice] = "<p>Compilation result:</p><pre>#{@compile_result.string}</pre>"
      redirect_to :action => "show", :id => params[:id]
    end
  end

  private
    def process_uploaded_file(file)
      # Create the folders if they doesn't exist
      FileUtils.mkdir_p(@problem.tests_dir)

      @upload = file

      if @upload.original_filename.end_with?("zip")
        # Extract the bundle
        Zip::ZipFile.foreach(@upload.tempfile.path) do |filename|
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

    def contest
      @contest ||= Contest.find(params[:contest_id])
    end
end
