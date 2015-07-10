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
    problem = contest.problems.build(params.require(:problem).permit!.except(:archive, :solution))

    if problem.save

      if !params[:problem][:archive].blank?
        ProcessUploadedFile.new(params[:problem][:archive], problem).extract
        ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
      end

      if !params[:problem][:solution].blank?
        Run.create!(:problem => problem,
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
    authorize problem.contest, :edit?
  end

  def edit
    authorize problem.contest, :edit?
  end

  def update
    params[:problem][:category_ids] ||= []

    authorize problem.contest, :edit?
    problem.attributes = params.require(:problem).permit(:id, :contest_id, :letter, :name, :time_limit, :created_at, :updated_at, :memory_limit, :diff_parameters, :category_ids => [])

    if problem.save
      redirect_to admin_contest_problems_path(problem.contest)
    else
      render :action => "edit"
    end
  end

  def toggle_runs_visible
    authorize problem

    problem.update_attribute(:runs_visible, !problem.runs_visible)
    redirect_to admin_contest_problems_path(problem.contest)
  end

  def purge_files
    authorize problem.contest, :edit?

    Dir[File.join(problem.tests_dir, "*")].each do |filename|
      next unless File.file?(filename)
      logger.warn "Deleting file #{filename}"
      File.delete filename
    end

    ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "Files successfully purged"

    redirect_to admin_contest_problem_path(problem.contest, problem)
  end

  def upload_file
    authorize problem.contest, :edit?
  end

  def do_upload_file
    authorize problem.contest, :edit?

    ProcessUploadedFile.new(params[:tests][:file], problem).extract

    ::Configuration.set!(::Configuration::TESTS_UPDATED_AT, Time.now.utc)
    flash[:notice] = "File successfully upoaded"

    redirect_to admin_contest_problem_path(problem.contest, problem)
  end

  def download_file
    authorize problem.contest, :edit?

    send_file File.join(problem.tests_dir, params[:file])
  end

  def compile_checker
    authorize problem.contest, :edit?

    checker_source = problem.checker_source
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

    def problem
      @problem ||= Problem.find(params[:id])
    end

    def contest
      @contest ||= Contest.find(params[:contest_id])
    end
end
