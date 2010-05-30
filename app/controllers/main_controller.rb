require 'ostruct'

class MainController < ApplicationController
  layout "main", :except => :results
  before_filter :check_user_profile
  
  def index
    @contests = Contest.current.select {|contest| contest.visible or current_user.andand.admin?}
    @practice_contests = Contest.practicable.select {|contest| contest.visible or current_user.andand.admin?}
    @top_scores = calc_rankings(:limit => 3)
  end
  
  def results
    @contest = Contest.find(params[:contest_id])
    if !(@contest.results_visible? or current_user.andand.admin?)
      redirect_to root_path
      return
    end
    
    @results = @contest.generate_contest_results
    @ratings = @results.map { |result| @contest.rating_changes.detect { |change| change.user == result.second } }

    render :action => :results, :layout => "results"
  end
  
  def rankings
    @rankings = calc_rankings
  end
  
  def activity
    @week_rankings = calc_rankings(:since => 7.days.ago, :only_active => true)
  end
  
  def download_tests
    Dir.chdir $config[:sets_root] do
      FileUtils.rm "sets.zip" if File.file?("sets.zip")
      Zip::ZipFile.open("sets.zip", Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("**/*") do |entry|
          zipfile.mkdir(entry) if File.directory?(entry)
          zipfile.add entry, entry if File.file?(entry)
        end
      end
    end

    send_file File.join($config[:sets_root], "sets.zip")
  end
  
  def status
    @runs = Run.paginate(:per_page => 50,
                         :joins => [:user, { :problem => :contest } ],
                         :page => params[:page],
                         :select => (Run.column_names - ["log", "source_code"]).map { |c| "runs.#{c}" }.join(","),
                         :conditions => ["contests.practicable AND contests.visible AND NOT users.admin"])
  end

  private
    def calc_rankings(options = {})
      rankings = User.generate_ranklist(options).map do |row|
        OpenStruct.new(
          :user => row[0],
          :total_points => row[1].to_i,
          :total_runs => row[2],
          :full_solutions => row[3],
          :rating => row[4])
      end
    end
end
